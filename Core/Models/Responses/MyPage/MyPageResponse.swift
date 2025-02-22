//
//  MyPageResponse.swift
//  Core
//
//  Created by Heeji Jung on 2/20/25.
//

import Foundation

public struct MyPageResponse: Codable {
    public let success: Bool
    public let message: String
    public let data: MyPageData
}

public struct MyPageData: Codable {
    public let userId: Int
    public var userName: String
    public var userGender: String
    public var userWeight: Double
    public var userHeight: Int
    public var userBirth: String
    public let socialProvider: String
}
