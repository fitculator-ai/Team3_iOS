//
//  MyPageRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

import Foundation

public struct MyPageRequest: Codable {
    let userId: Int
    var userName: String
    var userGender: String
    var userWeight: Double
    var userHeight: Int
    var userBirth: String
    let socialProvider: String
    var userHeartRate: Int
    
    public init(userId: Int, userName: String, userGender: String, userWeight: Double, userHeight: Int, userBirth: String, socialProvider: String, userHeartRate: Int) {
        self.userId = userId
        self.userName = userName
        self.userGender = userGender
        self.userWeight = userWeight
        self.userHeight = userHeight
        self.userBirth = userBirth
        self.socialProvider = socialProvider
        self.userHeartRate = userHeartRate
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "userName": userName,
            "userGender": userGender,
            "userWeight": userWeight,
            "userHeight": userHeight,
            "userBirth": userBirth,
            "socialProvider": socialProvider,
            "userHeartRate" : userHeartRate
        ]
    }
}


