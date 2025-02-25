//
//  ExerciseIntensityColor.swift
//  Shared
//
//  Created by Heeji Jung on 2/25/25.
//

import SwiftUI

public enum ExerciseIntensityColor: String {
    case veryHigh = "VERY HIGH"
    case high = "HIGH"
    case medium = "MEDIUM"
    case low = "LOW"
    case veryLow = "VERY LOW"
    
    // 각 강도에 대한 숫자 값을 반환 (int)
    public var intensityValue: Int {
        switch self {
        case .veryHigh: return 5
        case .high: return 4
        case .medium: return 3
        case .low: return 2
        case .veryLow: return 1
        }
    }
    
    // 한국어 텍스트 반환
    public var koreanText: String {
        switch self {
        case .veryHigh: return "매우 높음"
        case .high: return "높음"
        case .medium: return "보통"
        case .low: return "낮음"
        case .veryLow: return "매우 낮음"
        }
    }
    
    // 색상 반환
    public var color: Color {
        switch self {
        case .veryHigh: return .red
        case .high: return .purple
        case .medium: return Color.fitculatorLogo
        case .low: return .yellow
        case .veryLow: return .green
        }
    }
    
    // String을 ExerciseIntensityColor로 변환
    public static func from(_ intensity: String) -> ExerciseIntensityColor {
        return ExerciseIntensityColor(rawValue: intensity) ?? .medium
    }
}
