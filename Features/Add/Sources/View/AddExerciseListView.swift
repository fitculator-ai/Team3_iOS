//
//  AddExerciseListView.swift
//  Fitculator
//
//  Created by Song Kim on 2/14/25.
//

import SwiftUI
import Core

enum tapInfo : String, CaseIterable {
    case aerobic = "유산소"
    case anaerobic = "무산소"
}

public struct AddExerciseListView: View {
    @State private var selectedPicker: tapInfo = .aerobic
    
    public init() {}
    
    public var body: some View {
            ScrollView {
            Picker("운동 종류", selection: $selectedPicker) {
                ForEach(tapInfo.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
                if selectedPicker == .aerobic {
                    AddExerciseAerobicListView()
                } else {
                    AddExerciseAnaerobicListView()
                }
            }
    }
}

struct AddExerciseAerobicListView: View {
    var body: some View {
            ForEach(dummyExerciseTypeList) { item in
                Image(systemName: item.exerciseImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(Color(hex: item.exerciseColor))
                    .clipShape(Circle())
                    .padding()
            }
    }
}

struct AddExerciseAnaerobicListView: View {
    var body: some View {
            ForEach(dummyExerciseTypeList.reversed()) { item in
                Image(systemName: item.exerciseImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(Color(hex: item.exerciseColor))
                    .clipShape(Circle())
                    .padding()
            }
    }
}

#Preview {
    AddExerciseListView()
}
