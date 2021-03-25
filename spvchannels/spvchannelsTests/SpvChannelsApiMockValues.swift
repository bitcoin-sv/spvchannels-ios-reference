//
//  SpvChannelsApiMockValues.swift
//  spvchannelsTests
//  Created by Equaleyes Solutions
//

struct MockClientApiValues {
    static let getAllChannelsMock = """
    {
      "channels": [
        {
          "id": "testChannelId",
          "href": "string",
          "public_read": true,
          "public_write": true,
          "sequenced": true,
          "locked": true,
          "head": 0,
          "retention": {
            "min_age_days": 0,
            "max_age_days": 0,
            "auto_prune": true
          },
          "access_tokens": [
            {
              "id": "string",
              "token": "string",
              "description": "string",
              "can_read": true,
              "can_write": true
            }
          ]
        }
      ]
    }
    """

    static let getChannelMock = """
    {
      "id": "string",
      "href": "string",
      "public_read": true,
      "public_write": true,
      "sequenced": true,
      "locked": true,
      "head": 0,
      "retention": {
        "min_age_days": 0,
        "max_age_days": 0,
        "auto_prune": true
      },
      "access_tokens": [
        {
          "id": "string",
          "token": "string",
          "description": "string",
          "can_read": true,
          "can_write": true
        }
      ]
    }
    """

    static let getChannelTokenMock = """
    {
      "id": "string",
      "token": "string",
      "description": "string",
      "can_read": true,
      "can_write": true
    }
    """

    static let getAllChannelTokensMock = """
    [
        {
         "id": "string",
         "token": "string",
         "description": "string",
         "can_read": true,
         "can_write": true
        }
    ]
    """

    static let createChannelMock = """
    {
      "id": "string",
      "href": "string",
      "public_read": true,
      "public_write": true,
      "sequenced": true,
      "locked": true,
      "head": 0,
      "retention": {
        "min_age_days": 0,
        "max_age_days": 0,
        "auto_prune": true
      },
      "access_tokens": [
        {
          "id": "string",
          "token": "string",
          "description": "string",
          "can_read": true,
          "can_write": true
        }
      ]
    }
    """

    static let createChannelTokenMock = """
    {
      "id": "string",
      "token": "string",
      "description": "string",
      "can_read": true,
      "can_write": true
    }
    """
}
