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
    case anaerobic = "근력"
}

public struct AddExerciseListView: View {
    @State private var selectedPicker: tapInfo = .aerobic
    
    public init() {}

    public var body: some View {
        NavigationStack {
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
        .buttonStyle(.plain)
    }
}

struct AddExerciseAerobicListView: View {
    var body: some View {
        ForEach(dummyExerciseTypeList) { item in
            HStack {
                NavigationLink {
                    EmptyView()
                } label: {
                    Image(systemName: item.exerciseImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(8)
                        .background(Color(hex: item.exerciseColor))
                        .clipShape(Circle())
                        .padding(.leading, 20)
                    
                    
                    Text(item.exerciseName)
                        .bold()
                        .padding(.leading, 10)
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.88, height: 70)
            .background(Color.cellColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct AddExerciseAnaerobicListView: View {
    var body: some View {
        ForEach(dummyExerciseTypeList.reversed()) { item in
            HStack {
                NavigationLink {
                    EmptyView()
                } label: {
                    Image(systemName: item.exerciseImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(8)
                        .background(Color(hex: item.exerciseColor))
                        .clipShape(Circle())
                        .padding(.leading, 20)
                    
                    
                    Text(item.exerciseName)
                        .bold()
                        .padding(.leading, 10)
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.88, height: 70)
            .background(Color.cellColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    AddExerciseListView()
}
