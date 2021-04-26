//
//  SpvChannelsApiMockValues.swift
//  spvchannelsTests
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

struct MockClientApiValues {
    static let getAllChannelsMock = """
    {
        "channels": [
            {
                "id": "TestChannelId",
                "href": "https://localhost:5010/api/v1/channel/8TRp0CwBQShl2Y1ZuWSzchXAr5WaKhk65eQsjuhwamu5R8WsFJsXrLh6NZvSE9lzwD_wP4_ETPbQYbRWUESNLA",
                "public_read": true,
                "public_write": true,
                "sequenced": true,
                "locked": false,
                "head": 2,
                "retention": {
                    "min_age_days": 0,
                    "max_age_days": 0,
                    "auto_prune": true
                },
                "access_tokens": [
                    {
                        "id": "24",
                        "token": "j3Rx5mNcc-n95Kz6hYT3xc8vM-nMgJjNwxmHMh7CW7q8q75KGqrCnDrmzHaU-rS8wpy6ljcUZu75NjWApgytQg",
                        "description": "Owner",
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
