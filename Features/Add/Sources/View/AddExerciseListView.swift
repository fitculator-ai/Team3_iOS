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
    @StateObject private var viewModel = AddExerciseListViewModel()
    @State private var selectedPicker: tapInfo = .aerobic
    
    public init() {
        let appearance = UISegmentedControl.appearance()
        appearance.selectedSegmentTintColor = UIColor(Color.cellColor)
        appearance.backgroundColor = UIColor(Color.black)
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                    Color.background.ignoresSafeArea()
                
                ScrollView {
                    Picker("운동 종류", selection: $selectedPicker) {
                        ForEach(tapInfo.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: UIScreen.main.bounds.width * 0.88)
                    .padding(.vertical, 5)
                    
                    if selectedPicker == .aerobic {
                        ExerciseTypeListView(exerciseValues: "CARDIO", exerciseList: viewModel.exerciseCardioList)
                    } else {
                        ExerciseTypeListView(exerciseValues: "STRENGTH", exerciseList: viewModel.exerciseStrengthList)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            viewModel.fetchAddExerciseList(exerciseType: "CARDIO", userId: "1")
            viewModel.fetchAddExerciseList(exerciseType: "STRENGTH", userId: "1")
        }
    }
}

struct ExerciseTypeListView: View {
    let exerciseValues: String
    let exerciseList: [ExerciseType]
    
    var body: some View {
        ForEach(exerciseList) { item in
            NavigationLink {
                AddExerciseDetailView(exerciseKRName: item.exerciseKorName, exerciseENName: item.exerciseEngName, exerciseValues: exerciseValues)
            } label: {
                HStack {
                    Image(systemName: item.exerciseImg)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(8)
                        .background(Color(hex: item.exerciseColor))
                        .clipShape(Circle())
                        .padding(.leading, 20)
                    
                    Text(item.exerciseKorName)
                        .bold()
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.88, height: 70)
                .background(Color.cellColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

#Preview {
    AddExerciseListView()
}
