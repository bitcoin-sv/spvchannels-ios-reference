//
//  SpvChannelsTests.swift
//  spvchannelsTests
//  Created by Equaleyes Solutions
//

// swiftlint:disable file_length
import XCTest
@testable import spvchannels

class MockClientApi {
    var baseUrl: String = ""
    var credentials = SpvCredentials(accountId: "", userName: "", password: "")

    var shouldReturnError = false
    var getAllChannelsWasCalled = false
    var getChannelWasCalled = false
    var getChannelTokenWasCalled = false
    var createChannelWasCalled = false
    var deleteChannelWasCalled = false
    var amendChannelWasCalled = false
    var getAllChannelTokensWasCalled = false
    var createChannelTokenWasCalled = false
    var revokeChannelTokenWasCalled = false

    func reset() {
        getAllChannelsWasCalled = false
        getChannelWasCalled = false
        getChannelTokenWasCalled = false
        createChannelWasCalled = false
        deleteChannelWasCalled = false
        amendChannelWasCalled = false
        getAllChannelTokensWasCalled = false
        createChannelTokenWasCalled = false
        revokeChannelTokenWasCalled = false
    }

    init(_ shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    convenience init() {
        self.init(false)
    }
}

extension MockClientApi: SpvChannelsApiProtocol {

    func getAllChannels(accountId: String, completion: @escaping ChannelsInfoResult) {
        getAllChannelsWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            if let result = ChannelsList.parse(from: MockClientApiValues.getAllChannelsMock, type: ChannelsList.self) {
                completion(.success(result.channels))
            } else {
                completion(.failure(.noContent))
            }
        }
    }

    func getChannel(accountId: String, channelId: String, completion: @escaping ChannelInfoResult) {
        getChannelWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            if let result = ChannelInfo.parse(from: MockClientApiValues.getChannelMock, type: ChannelInfo.self) {
                completion(.success(result))
            }
        }
    }

    func getChannelToken(accountId: String, channelId: String, tokenId: String, completion: @escaping TokenInfoResult) {
        getChannelTokenWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            if let result = ChannelToken.parse(from: MockClientApiValues.getChannelTokenMock, type: ChannelToken.self) {
                completion(.success(result))
            }
        }
    }

    func createChannel(accountId: String, completion: @escaping ChannelInfoResult) {
        createChannelWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            if let result = ChannelInfo.parse(from: MockClientApiValues.createChannelMock, type: ChannelInfo.self) {
                completion(.success(result))
            } else {
                completion(.failure(.noContent))
            }
        }
    }

    func deleteChannel(accountId: String, channelId: String, completion: @escaping VoidResult) {
        deleteChannelWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            completion(.success(()))
        }
    }

    func amendChannel(accountId: String, channelId: String, permissions: ChannelPermissions,
                      completion: @escaping VoidResult) {
        amendChannelWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            completion(.success(()))
        }
    }

    func createChannelToken(accountId: String, channelId: String, tokenRequest: CreateTokenRequest,
                            completion: @escaping TokenInfoResult) {
        createChannelTokenWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            if let result = ChannelToken.parse(from: MockClientApiValues.createChannelTokenMock,
                                               type: ChannelToken.self) {
                completion(.success(result))
            }
        }
    }

    func getAllChannelTokens(accountId: String, channelId: String, completion: @escaping TokensInfoResult) {
        getAllChannelTokensWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            if let result = [ChannelToken].parse(from: MockClientApiValues.getAllChannelTokensMock,
                                              type: [ChannelToken].self) {
                completion(.success(result))
            }
        }
    }

    func revokeChannelToken(accountId: String, channelId: String, tokenId: String, completion: @escaping VoidResult) {
        revokeChannelTokenWasCalled = true
        if shouldReturnError {
            completion(.failure(.noContent))
        } else {
            completion(.success(()))
        }
    }

}

class SpvChannelsTests: XCTestCase {

    var sut = MockClientApi()

    override func setUpWithError() throws {
        sut.shouldReturnError = false
    }

    override func tearDownWithError() throws {
        sut.reset()
    }
}

extension SpvChannelsTests {

    var timeout: Double { 1.0 }

    // MARK: getAllChannels
    func testGetAllChannelsIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.getAllChannels(accountId: "1") { _ in }
        XCTAssert(sut.getAllChannelsWasCalled)
    }

    func testGetAllChannelsReturnsValues() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for getAllChannels() to return values")
        sut.getAllChannels(accountId: "1") { result in
            if case .success(let data) = result,
               data.count == 1 {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetAllChannelsReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for getAllChannels() to return error on fail")
        sut.getAllChannels(accountId: "1") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: getChannel
    func testGetChannelIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.getChannel(accountId: "1", channelId: "2") { _ in }
        XCTAssert(sut.getChannelWasCalled)
    }

    func testGetChannelReturnsValue() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for getChannel() to return values")
        sut.getChannel(accountId: "1", channelId: "2") { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetChannelReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for getChannel() to return error on fail")
        sut.getChannel(accountId: "1", channelId: "2") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: getChannelToken
    func testGetChannelTokenIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.getChannelToken(accountId: "1", channelId: "2", tokenId: "3") { _ in }
        XCTAssert(sut.getChannelTokenWasCalled)
    }

    func testGetChannelTokenReturnsValue() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for getChannelToken() to return values")
        sut.getChannelToken(accountId: "1", channelId: "2", tokenId: "3") { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetChannelTokenReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for getChannelToken() to return error on fail")
        sut.getChannelToken(accountId: "1", channelId: "2", tokenId: "3") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: createChannel
    func testCreateChannelIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.createChannel(accountId: "1") { _ in }
        XCTAssert(sut.createChannelWasCalled)
    }

    func testCreateChannelReturnsValues() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for createChannel() to return values")
        sut.createChannel(accountId: "1") { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateChannelReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for createChannel() to return error on fail")
        sut.createChannel(accountId: "1") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: deleteChannel
    func testDeleteChannelIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.deleteChannel(accountId: "1", channelId: "2") { _ in }
        XCTAssert(sut.deleteChannelWasCalled)
    }

    func testCreateChannelReturnsSuccess() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for deleteChannel() to return success")
        sut.deleteChannel(accountId: "1", channelId: "2") { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteChannelReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for deleteChannel() to return error on fail")
        sut.deleteChannel(accountId: "1", channelId: "2") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: amendChannel
    func testAmendChannelIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.amendChannel(accountId: "1", channelId: "2",
                         permissions: ChannelPermissions(publicRead: true, publicWrite: true, locked: true)) { _ in }
        XCTAssert(sut.amendChannelWasCalled)
    }

    func testAmendChannelReturnsSuccess() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for amendChannel() to return success")
        sut.amendChannel(accountId: "1", channelId: "2",
                         permissions: ChannelPermissions(publicRead: true, publicWrite: true, locked: true)) { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testAmendChannelReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for amendChannel() to return error on fail")
        sut.amendChannel(accountId: "1", channelId: "2",
                         permissions: ChannelPermissions(publicRead: true, publicWrite: true, locked: true)) { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: getAllChannelTokens
    func testGetAllChannelTokensIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.getAllChannelTokens(accountId: "1", channelId: "2") { _ in }
        XCTAssert(sut.getAllChannelTokensWasCalled)
    }

    func testGetAllChannelTokensReturnsValue() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for getAllChannelTokens() to return values")
        sut.getAllChannelTokens(accountId: "1", channelId: "2") { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetAllChannelTokensReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for getAllChannelTokens() to return error on fail")
        sut.getAllChannelTokens(accountId: "1", channelId: "2") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: revokeChannelToken
    func testRevokeChannelTokenIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        sut.revokeChannelToken(accountId: "1", channelId: "2", tokenId: "3") { _ in }
        XCTAssert(sut.revokeChannelTokenWasCalled)
    }

    func testRevokeChannelTokenReturnsSuccess() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for revokeChannelToken() to return success")
        sut.revokeChannelToken(accountId: "1", channelId: "2", tokenId: "3") { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testRevokeChannelTokenReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for revokeChannelToken() to return error on fail")
        sut.getChannelToken(accountId: "1", channelId: "2", tokenId: "3") { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: createChannelToken
    func testCreateChannelTokenIsCalled() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let tokenRequest = CreateTokenRequest(canRead: true, canWrite: true, description: "test")
        sut.createChannelToken(accountId: "1", channelId: "2", tokenRequest: tokenRequest) { _ in }
        XCTAssert(sut.createChannelTokenWasCalled)
    }

    func testCreateChannelTokenReturnsValue() throws {
        // Given
        sut.shouldReturnError = false
        // When
        let expect = expectation(description: "Wait for createChannelToken() to return value")
        let tokenRequest = CreateTokenRequest(canRead: true, canWrite: true, description: "test")
        sut.createChannelToken(accountId: "1", channelId: "2", tokenRequest: tokenRequest) { result in
            if case .success = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateChannelTokenReturnsErrorOnFail() throws {
        // Given
        sut.shouldReturnError = true
        // When
        let expect = expectation(description: "Wait for createChannelToken() to return error on fail")
        let tokenRequest = CreateTokenRequest(canRead: true, canWrite: true, description: "test")
        sut.createChannelToken(accountId: "1", channelId: "2", tokenRequest: tokenRequest) { result in
            if case .failure = result {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }

}
