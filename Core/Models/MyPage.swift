//
//  myPage.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import Foundation

//MARK: 유저 정보
public struct MyPage: Identifiable {
    
    public let id = UUID()
    public let userid: Int64
    public var userName: String
    public var userGender: String
    public var userweight: Double
    public var userheight: Int32
    public var userBirth: String
    public var socialProvider: String
    
    
    public init(userid: Int64, userName: String, userGender: String, userweight: Double, userheight: Int32, userBirth: String, socialProvider: String) {
        self.userid = userid
        self.userName = userName
        self.userGender = userGender
        self.userweight = userweight
        self.userheight = userheight
        self.userBirth = userBirth
        self.socialProvider = socialProvider
    }
}

//MARK: 유저 안정시 심박수
public struct heartUpdate {
    public var userHeartRate: Int32
    public let userid: Int64
}
