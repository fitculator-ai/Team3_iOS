//
//  ProfileViewModel.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import Foundation
import Core

class ProfileViewModel: ObservableObject{
    
    @Published var profiledata: MyPage
    
    let genders = ["남성", "여성"]
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    init() {
        let defaultUser = MyPage(
            userid: 12345,
            userName: "홍길동",
            userGender: "남성",
            userweight: 70.0,
            userheight: 175,
            userBirth: "1990-12-09",
            socialProvider: "Kakao"
        )
        self.profiledata = defaultUser
    }
    
    //MARK: 사용자 정보 유효성 검사
    // 유저 이름
    var isUserNameValid: Bool {
        return !profiledata.userName.isEmpty && profiledata.userName.count <= 15
    }
    
    // 유저 몸무게
    var isUserWeightValid: Bool {
        return profiledata.userweight > 0
    }
    
    //유저 키
    var isUserHeightValid: Bool {
        return profiledata.userheight > 0
    }
    
    // 사용자 정보 유효성 전체 검사
    var isFormValid: Bool {
        return isUserNameValid && isUserWeightValid && isUserHeightValid
    }
    
}

