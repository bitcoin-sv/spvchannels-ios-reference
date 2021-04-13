//
//  SpvChannelsTests.swift
//  spvchannelsTests
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

// swiftlint:disable line_length
import XCTest
@testable import spvchannels

class MockURLSession: NetworkSessionProtocol {

    var mockData: ((URLRequest) -> Data?)?
    var mockError: ((URLRequest) -> Error?)?
    var mockUrlResponse: ((URLRequest) -> URLResponse)?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol? {
        completionHandler(mockData?(request), mockUrlResponse?(request), mockError?(request))
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
    func cancel() {}
}

class SpvChannelApiTests: XCTestCase {

    var sdk: SpvChannelsSdk!
    var channelApi: SpvChannelApi!
    var messagingApi: SpvMessagingApi!
    var mockSession: MockURLSession!

    let timeout: TimeInterval = 1.0

    override func setUpWithError() throws {
        mockSession = MockURLSession()

        sdk = SpvChannelsSdk(baseUrl: "")
        channelApi = SpvChannelApi(baseUrl: "https://mock", accountId: "c1", username: "c2", password: "c3", networkSession: mockSession)
        messagingApi = SpvMessagingApi(baseUrl: "https://mock", channelId: "m1", token: "m2", encryption: SpvNoOpEncryption(), networkSession: mockSession)
    }

    override func tearDownWithError() throws {
    }

    func testChannelApiHasBasicAuth() {
        mockSession.mockError = nil
        mockSession.mockData = nil
        let expect = expectation(description: "Check HTTP header for Basic auth")
        let expectedAuth = "Basic YzI6YzM=" // Basic c2:c3
        mockSession.mockUrlResponse = { request in
            expect.fulfill()
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), expectedAuth)
            return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        }

        channelApi.getAllChannels { _ in }
        waitForExpectations(timeout: timeout)
    }

    func testGetAllChannelsReturnsValueOnSuccess() {
        mockSession.mockError = nil
        mockSession.mockData = { _ in
            MockClientApiValues.getAllChannelsMock.data(using: .utf8)
        }
        mockSession.mockUrlResponse = { request in
            HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        }
        let expect = expectation(description: "Wait for getAllChannels() to return correct mock value")

        var channelsList: ChannelsList?
        channelApi.getAllChannels { result in
            switch result {
            case .success(let data):
                channelsList = data
                expect.fulfill()
            case .failure: break
            }
        }
        waitForExpectations(timeout: timeout)
        XCTAssertEqual(channelsList?.channels.count, 1)
        XCTAssertEqual(channelsList?.channels[0].id, "TestChannelId")
    }

    func testGetAllChannelsFailsOnError() {
        mockSession.mockError = nil
        mockSession.mockData = { _ in
            MockClientApiValues.getAllChannelsMock.data(using: .utf8)
        }
        mockSession.mockUrlResponse = { request in
            HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
        }
        let expect = expectation(description: "Wait for getAllChannels() to fail on 404 error")

        channelApi.getAllChannels { result in
            switch result {
            case .success: break
            case .failure:
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetAllChannelsFailsOnBadJson() {
        mockSession.mockError = nil
        mockSession.mockData = { _ in
            "some malformed not-JSON text".data(using: .utf8)
        }
        mockSession.mockUrlResponse = { request in
            HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        }
        let expect = expectation(description: "Wait for getAllChannels() to fail on bad JSON response")

        channelApi.getAllChannels { result in
            switch result {
            case .success: break
            case .failure:
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

}
