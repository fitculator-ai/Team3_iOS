//
//  WorkoutUpdateRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct WorkoutUpdateRequest: Codable {
    let recordId: Int
    let userId: Int
    let memo: String
    
    public func toDictionary() -> [String: Any] {
        return [
            "recordId": recordId,
            "userId": userId,
            "memo": memo
        ]
    }
}
