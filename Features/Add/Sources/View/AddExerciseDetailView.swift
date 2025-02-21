//
//  AddExerciseDetailView.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI
import Core

struct AddExerciseDetailView: View {
    let exerciseName: String
    let exerciseValues: String
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modalManager: AddModalManager
    @ObservedObject var viewModel = AddExerciseDetailViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.cellColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack {
                    HStack {
                        Text("평균 심박수")
                            .opacity(0.7)
                        TextField("", text: $viewModel.averageHeartRate)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Divider()
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("최대 심박수")
                            .opacity(0.7)
                        TextField("", text: $viewModel.maxHeartRate)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width * 0.88, height: 95)
            .padding(.top, 10)
            
            ZStack {
                Rectangle()
                    .fill(Color.cellColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading) {
                    DatePicker("시작 날짜", selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: .date)
                        .opacity(0.7)
                        .padding(.top, -8)
                    
                    Divider()
                    
                    DatePicker("시작 시간", selection: $viewModel.selectedDate, displayedComponents: .hourAndMinute)
                        .opacity(0.7)
                    
                    Divider()
                        .padding(.bottom, 7)
                    
                    HStack {
                        Text("운동 시간(분)")
                            .opacity(0.7)
                        TextField("", text: $viewModel.workoutDuration)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width * 0.88, height: 154)
            .padding(.top, 10)
            
            ZStack {
                Color.cellColor
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment:.leading) {
                    Text("메모")
                        .opacity(0.7)
                    
                    Divider()
                    
                    TextEditor(text: $viewModel.workoutMemo)
                        .scrollContentBackground(.hidden)
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width * 0.88, height: 200)
            .padding(.top, 10)
            
            Spacer()
        }
        .navigationTitle(exerciseName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    modalManager.isModalPresented = false
                    
                    let exerciseData = WorkoutRequest(
                        userId: 1,
                        exerciseType: "CARDIO",
                        exerciseKorName: exerciseName,
                        exerciseEngName: exerciseName,
                        recordDate: DateFormatterUtil.dateFormatDate.string(from: viewModel.selectedDate),
                        recordStart: DateFormatterUtil.dateFormatTime.string(from: viewModel.selectedDate),
                        duration: Int(viewModel.workoutDuration)!,
                        avgHeartRate: Int(viewModel.averageHeartRate) ?? 0,
                        highHeartRate: Int(viewModel.maxHeartRate) ?? 0,
                        memo: viewModel.workoutMemo
                    )
                    
                    print("recordStart: \(exerciseData)")
                    viewModel.fetchCreateWorkout(request: exerciseData)
                }
            }
        }
    }
}

#Preview {
    AddExerciseDetailView(exerciseName: "런닝", exerciseValues: "CARDIO")
}
