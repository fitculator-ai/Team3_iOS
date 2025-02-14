//
//  AddExerciseListView.swift
//  Fitculator
//
//  Created by Song Kim on 2/14/25.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        guard hexSanitized.count == 6, let intCode = Int(hexSanitized, radix: 16) else {
            return nil
        }
        
        let red = Double((intCode >> 16) & 0xFF) / 255.0
        let green = Double((intCode >> 8) & 0xFF) / 255.0
        let blue = Double(intCode & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    var exerciseName: String
    var exerciseType: String
    var exerciseColor: String
    var exerciseImage: String
    
    var color: Color {
        Color(hex: exerciseColor) ?? .black
    }
}

var aerobicList: [Exercise] = [
    Exercise(exerciseName: "Running", exerciseType: "Cardio", exerciseColor: "#FF0000", exerciseImage: "figure.run"),         // 빨강
    Exercise(exerciseName: "Cycling", exerciseType: "Cardio", exerciseColor: "#3498DB", exerciseImage: "bicycle"),           // 파랑
    Exercise(exerciseName: "Swimming", exerciseType: "Cardio", exerciseColor: "#1ABC9C", exerciseImage: "figure.pool.swim"), // 청록
    Exercise(exerciseName: "Jump Rope", exerciseType: "Cardio", exerciseColor: "#F1C40F", exerciseImage: "figure.jumprope"), // 노랑
    Exercise(exerciseName: "Rowing", exerciseType: "Cardio", exerciseColor: "#27AE60", exerciseImage: "figure.rower"),       // 녹색
    Exercise(exerciseName: "Hiking", exerciseType: "Cardio", exerciseColor: "#8B4513", exerciseImage: "figure.hiking"),      // 갈색
    Exercise(exerciseName: "Elliptical", exerciseType: "Cardio", exerciseColor: "#9B59B6", exerciseImage: "figure.elliptical"), // 보라
    Exercise(exerciseName: "Stair Climbing", exerciseType: "Cardio", exerciseColor: "#E67E22", exerciseImage: "figure.stair.stepper"), // 주황
    Exercise(exerciseName: "Dancing", exerciseType: "Cardio", exerciseColor: "#E91E63", exerciseImage: "figure.dance"),      // 핑크
    Exercise(exerciseName: "Kickboxing", exerciseType: "Cardio", exerciseColor: "#7F8C8D", exerciseImage: "figure.kickboxing") // 회색
]


public struct AddExerciseListView: View {
    public init() {}
    public var body: some View {
        VStack {
            AddExerciseAerobicListView()
        }
    }
}

struct AddExerciseAerobicListView: View {
    var body: some View {
        ForEach(aerobicList) { item in
            Image(systemName: item.exerciseImage)
                .resizable()
                .frame(width: 50, height: 50)
                .background(item.color) // Hex 변환된 색상 적용
                .clipShape(Circle()) // 원형 배경
                .padding()
        }
    }
}

#Preview {
    AddExerciseListView()
}
