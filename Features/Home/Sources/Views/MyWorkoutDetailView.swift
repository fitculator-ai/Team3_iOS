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
                        Text(workout.exerciseKorName)
                            .font(AppFont.subTitle)
                        Text("\(viewModel.getDateToTime(dateString: workout.recordStart)) - \(viewModel.getDateToTime(dateString: workout.recordEnd))")
                            .font(.system(size: 16))
                    }
                    Spacer()
                    Text("\(workout.recordPoint)pt")
                        .font(AppFont.mainTitle)
                }
                .padding(.vertical)
                
                Text("운동 세부사항")
                    .font(AppFont.subTitle)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cellColor)
                        .frame(height: 250)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("평균 심박수")
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
                            Text("운동 시간")
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
                            Text("운동 강도")
                                .font(AppFont.cellTitle)
                            Text(viewModel.getIntensityText(workout.intensity))
                                .font(AppFont.subTitle)
                                .foregroundStyle(viewModel.getIntensityColor(workout.intensity))
                                .padding(.vertical, 3)
                        }
                    }
                }
                .padding(.bottom)
                
                Text("메모")
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
                            Text("취소")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("저장") {
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
                Button("수정") {
                    isEditing = true
                    isFocused = true
                }
                Button("삭제", role: .destructive) {
                    print("삭제 선택됨")
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
}
