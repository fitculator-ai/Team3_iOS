//
//  MyWorkoutListView.swift
//  Features
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI
import Core
import Shared

public struct MyWorkoutListView: View {
    @StateObject private var viewModel = MyWorkoutViewModel()
    @State private var selectedWorkout: WorkoutRecord?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("나의 운동 기록")
                    .font(AppFont.mainTitle)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if viewModel.workoutRecords.isEmpty {
                    Text("운동 기록이 없습니다.")
                        .font(AppFont.subTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.workoutRecords, id: \.id) { workout in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.cellColor)
                                        .frame(height: 160)
                                        .onTapGesture {
                                            selectedWorkout = workout
                                        }
                                    VStack {
                                        HStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color(hex: workout.exerciseColor))
                                                    .frame(width: 45, height: 45)
                                                Image(systemName: workout.exerciseImg)
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                            }
                                            VStack(alignment: .leading) {
                                                Text(workout.exerciseKorName)
                                                    .font(AppFont.subTitle)
                                                Text("02.11 오후 6:50")
                                                    .font(.system(size: 13))
                                                    .opacity(0.8)
                                            }
                                            Spacer()
                                            Text("111.1pt")
                                                .font(.system(size: 26))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 25)
                                        .padding(.bottom, 20)
                                        
                                        HStack {
                                            workoutInfo(title: "시간", value: "100min")
                                            Spacer()
                                            workoutInfo(title: "평균 심박수", value: "150bpm")
                                            Spacer()
                                            workoutInfo(title: "운동 강도", value: "매우 높음", color: .green)
                                        }
                                        .padding(.horizontal, 30)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.88)
                            }
                        }
                    }
                    //                    .navigationDestination(item: $selectedWorkout) { workout in
                    //                        MyWorkoutDetailView(workout: workout)
                    //                    }
                }
            }
            .padding()
        }
        .onAppear{
            viewModel.fetchWeeklyWorkout(userId: 1, targetDate: "2025-01-13")
        }
    }
    
    private func workoutInfo(title: String, value: String, color: Color = .primary) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 13))
                .opacity(0.8)
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    MyWorkoutListView()
}
