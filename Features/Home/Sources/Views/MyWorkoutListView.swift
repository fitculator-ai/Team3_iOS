//
//  MyWorkoutListView.swift
//  Features
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI
import Core
import Shared

struct MyWorkoutListView: View {
    @ObservedObject private var viewModel: HomeViewModel
    @Binding private var selectedWorkout: WorkoutRecord?
    
    init(viewModel: HomeViewModel,
         selectedWorkout: Binding<WorkoutRecord?>) {
        self.viewModel = viewModel
        self._selectedWorkout = selectedWorkout
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("myWorkoutRecord")
                .font(AppFont.subTitle)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if viewModel.workoutData?.records.isEmpty ?? true {
                Text("startYourWorkout")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                NavigationStack {
                    LazyVStack {
                        ForEach(viewModel.workoutData?.records.sorted(by: { $0.recordStart > $1.recordStart }) ?? []
                                , id: \.id) { workout in
                            NavigationLink(value: workout) {
                                WorkoutRecordRow(workout: workout, viewModel: viewModel, selectedWorkout: $selectedWorkout)
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedWorkout = workout
                            })
                        }
                    }
                    .navigationDestination(for: WorkoutRecord.self) { workout in
                        MyWorkoutDetailView(viewModel: viewModel, workout: workout)
                    }
                }
            }
        }
        .padding(.top)
    }
}

// Workout Cell View
struct WorkoutRecordRow: View {
    let workout: WorkoutRecord
    let viewModel: HomeViewModel
    @Binding var selectedWorkout: WorkoutRecord?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.cellColor)
                .frame(height: 160)
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
                        Text(viewModel.getDateToDateTime(dateString: workout.recordStart))
                            .font(.system(size: 13))
                            .opacity(0.8)
                    }
                    Spacer()
                    Text("\(workout.recordPoint)pt")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
                
                HStack {
                    workoutInfo(title: "time", value: "\(workout.duration)min")
                    Spacer()
                    workoutInfo(title: "average", value: "\(workout.avgHeartRate)bpm")
                    Spacer()
                    workoutInfo(
                        title: "exerciseIntensity",
                        value: viewModel.getIntensityText(workout.intensity),
                        color: viewModel.getIntensityColor(workout.intensity)
                    )
                }
                .padding(.horizontal, 30)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.88)
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
