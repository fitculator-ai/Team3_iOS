//
//  MyWorkoutDetailView.swift
//  Features
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI
import Shared
import Core

struct MyWorkoutDetailView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showDialog: Bool = false
    @State private var isEditing: Bool = false
    @State private var textEditor: String = ""
    @State private var originalText: String = ""
    @State private var showDeleteAlert = false
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var workout: WorkoutRecord
    
    init(viewModel: HomeViewModel, workout: WorkoutRecord) {
        self.viewModel = viewModel
        self.workout = workout
        _textEditor = State(initialValue: workout.memo ?? "")
        _originalText = State(initialValue: workout.memo ?? "")
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: workout.exerciseColor))
                            .frame(width: 75, height: 75)
                        Image(systemName: workout.exerciseImg)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    VStack(alignment: .leading) {
                        Text(currentLanguage() == "kr" ? workout.exerciseKorName : workout.exerciseEngName)
                            .font(AppFont.subTitle)
                        Text("\(viewModel.getDateToTime(dateString: workout.recordStart)) - \(viewModel.getDateToTime(dateString: workout.recordEnd))")
                            .font(.system(size: 16))
                    }
                    Spacer()
                    if workout.recordPoint > 0 {
                        Text("\(workout.recordPoint)pt")
                            .font(AppFont.mainTitle)
                    }
                }
                .padding(.vertical)
                
                Text("exerciseDetails")
                    .font(AppFont.subTitle)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cellColor)
                        .frame(height: 250)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("averageHeartRate")
                                .font(AppFont.cellTitle)
                            HStack {
                                Text("\(workout.avgHeartRate)")
                                    .font(AppFont.subTitle)
                                Text("bpm")
                            }
                            .padding(.vertical, 3)
                        }
                        
                        Divider()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 3)
                            .padding(.bottom, 3)
                        
                        VStack(alignment: .leading) {
                            Text("exerciseDurationInMinutes")
                                .font(AppFont.cellTitle)
                            HStack {
                                Text("\(workout.duration)")
                                    .font(AppFont.subTitle)
                                Text("min")
                            }
                            .padding(.vertical, 3)
                        }
                        
                        Divider()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 3)
                            .padding(.bottom, 3)
                        
                        VStack(alignment: .leading) {
                            Text("exerciseIntensity")
                                .font(AppFont.cellTitle)
                            Text(viewModel.getIntensityText(workout.intensity))
                                .font(AppFont.subTitle)
                                .foregroundStyle(viewModel.getIntensityColor(workout.intensity))
                                .padding(.vertical, 3)
                        }
                    }
                }
                .padding(.bottom)
                
                Text("memo")
                    .font(AppFont.subTitle)
                
                ScrollableTextEditor(
                    text: $textEditor,
                    isEditing: isEditing,
                    isFocused: $isFocused
                )
                .frame(height: 150)
                .focused($isFocused)
                .cornerRadius(10)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.88)
            .navigationTitle(viewModel.getDateToDay(dateString: workout.recordStart))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if !isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showDialog = true
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            textEditor = originalText
                            isEditing = false
                            isFocused = false
                        } label: {
                            Text("cancel")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("save") {
                            originalText = textEditor
                            viewModel.updateWorkoutMemo(
                                request: WorkoutUpdateRequest(
                                    recordId: workout.recordId,
                                    userId: 1,
                                    memo: originalText)
                            )
                            isEditing = false
                            isFocused = false
                        }
                    }
                }
            }
            .confirmationDialog("MyWorkoutEdit", isPresented: $showDialog) {
                Button("edit") {
                    isEditing = true
                    isFocused = true
                }
                Button("delete", role: .destructive) {
                    showDeleteAlert = true
                }
                Button("cancel", role: .cancel) {}
            }
            .alert(NSLocalizedString("deleteExerciseRecord", comment: ""), isPresented: $showDeleteAlert) {
                Button("cancel", role: .cancel) {
                    showDeleteAlert = false
                }
                Button("delete", role: .destructive) {
                    viewModel.deleteWorkout(userId: 1, recordId: workout.recordId)
                    viewModel.fetchFirstWorkoutDate(userId: 1)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("deleteExerciseRecordConfirmation")
            }
        }
    }
}
