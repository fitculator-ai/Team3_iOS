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
    
    public init(recordId: Int, userId: Int, memo: String) {
        self.recordId = recordId
        self.userId = userId
        self.memo = memo
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "recordId": recordId,
            "userId": userId,
            "memo": memo
        ]
    }
}
