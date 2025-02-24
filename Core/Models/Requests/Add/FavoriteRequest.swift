//
//  FavoriteRequest.swift
//  Fitculator
//
//  Created by Song Kim on 2/24/25.
//

public struct FavoriteRequest: Codable {
    let userId: Int
    let exerciseId: Int
    
    public init(userId: Int, exerciseId: Int) {
        self.userId = userId
        self.exerciseId = exerciseId
    }

    public func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "exerciseId": exerciseId
        ]
    }
}
