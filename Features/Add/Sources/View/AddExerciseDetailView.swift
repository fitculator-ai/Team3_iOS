//
//  AddExerciseDetailView.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI
import Core

struct AddExerciseDetailView: View {
    let exerciseKRName: String
    let exerciseENName: String
    let exerciseValue: String
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modalManager: AddModalManager
    @ObservedObject var viewModel = AddExerciseDetailViewModel()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.cellColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack {
                        HStack {
                            Text("averageHeartRate")
                                .opacity(0.7)
                            NumberTextField(text: $viewModel.avgHeartRate)
                        }
                        
                        Divider()
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("maxHeartRate")
                                .opacity(0.7)
                            NumberTextField(text: $viewModel.maxHeartRate)
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
                        DatePicker(NSLocalizedString("startDate", comment: ""), selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: .date)
                            .opacity(0.7)
                            .padding(.top, -8)
                        
                        Divider()
                        
                        DatePicker(NSLocalizedString("startTime", comment: ""), selection: $viewModel.selectedDate, displayedComponents: .hourAndMinute)
                            .opacity(0.7)
                        
                        Divider()
                            .padding(.bottom, 7)
                        
                        HStack {
                            Text("exerciseDurationInMinutes")
                                .opacity(0.7)
                            NumberTextField(text: $viewModel.duration)
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
                        Text(NSLocalizedString("memo", comment: ""))
                            .opacity(0.7)
                        
                        Divider()
                        
                        TextEditor(text: $viewModel.memo)
                            .scrollContentBackground(.hidden)
                    }
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width * 0.88, height: 200)
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .navigationTitle(currentLanguage() == "ko" ? exerciseKRName : exerciseENName)
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
                Button("save") {
                    modalManager.shouldUpdateHomeView = true
                    modalManager.isModalPresented = false
                    
                    let exerciseData = WorkoutRequest(
                        userId: 1,
                        exerciseType: exerciseValue,
                        exerciseKorName: exerciseKRName,
                        exerciseEngName: exerciseENName,
                        recordDate: DateFormatterUtil.dateFormatDate.string(from: viewModel.selectedDate),
                        recordStart: DateFormatterUtil.dateFormatTime.string(from: viewModel.selectedDate),
                        duration: Int(viewModel.duration) ?? 0,
                        avgHeartRate: Int(viewModel.avgHeartRate) ?? 0,
                        highHeartRate: Int(viewModel.maxHeartRate) ?? 0,
                        memo: viewModel.memo
                    )
                    
                    viewModel.fetchCreateWorkout(request: exerciseData)
                }
            }
        }
    }
}
