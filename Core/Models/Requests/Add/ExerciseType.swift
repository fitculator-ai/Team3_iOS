//
//  Exercise.swift
//  Fitculator
//
//  Created by Song Kim on 2/14/25.
//

import Foundation

public struct ExerciseType: Codable, Identifiable {
    public var id: Int { exerciseId }
    public let exerciseId: Int
    public let exerciseKorName: String
    public let exerciseEngName: String
    public let exerciseType: String
    public let exerciseColor: String
    public let exerciseImg: String
    public let favoriteYn: String

    init() {
        self.exerciseId = 0
        self.exerciseKorName = ""
        self.exerciseEngName = ""
        self.exerciseType = ""
        self.exerciseColor = ""
        self.exerciseImg = ""
        self.favoriteYn = ""
    }
}
