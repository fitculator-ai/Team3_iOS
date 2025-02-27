//
//  HomeView.swift
//  Features
//
//  Created by 김영훈 on 2/14/25.
//

import SwiftUI
import UIKit
import Shared
import Core

public struct HomeView: View {
    public init() {}
    @EnvironmentObject var addModalManager: AddModalManager
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var showDatePicker = false
    @State private var selectedWorkout: WorkoutRecord?
    private let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        HomeNavigationBar()
                        
                        HStack(spacing: 20) {
                            Spacer()
                            
                            Button(action: {
                                if let previousWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: viewModel.selectedDate) {
                                    viewModel.selectedDate = previousWeekDate
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                                    .foregroundStyle(viewModel.checkIsFirstWeek() ? Color.disabledColor : Color.basicColor)
                            }
                            .disabled(viewModel.checkIsFirstWeek())
                            
                            Text(viewModel.getSelectedWeekString())
                                .font(.subheadline)
                                .fontWeight(
                                    [NSLocalizedString("thisWeeksExerciseAmount", comment: ""), NSLocalizedString("lastWeeksExerciseAmount", comment: "")].contains(viewModel.getSelectedWeekString()) ? .semibold : .regular
                                )
                                .padding([.leading, .trailing], 24)
                                .padding([.top, .bottom], 8)
                                .frame(width: 228)
                                .background(Color.cellColor)
                                .clipShape(RoundedRectangle(cornerRadius: 36))
                                .onTapGesture {
                                    showDatePicker.toggle()
                                }
                            
                            Button(action: {
                                if let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: +1, to: viewModel.selectedDate) {
                                    viewModel.selectedDate = nextWeekDate
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                                    .foregroundStyle(viewModel.checkIsCurrentWeek() ? Color.disabledColor : Color.basicColor)
                            }
                            .disabled(viewModel.checkIsCurrentWeek())
                            
                            Spacer()
                        }
                        ZStack(alignment: .top) {
                            VStack {
                                ExercisePieChartView(data: viewModel.workoutRecordPointSums)
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7)
                                
                                HStack {
                                    Image(systemName: viewModel.pointPercentageDifference >= 0 ? "arrowshape.up.circle" : "arrowshape.down.circle")
                                    Text("\(NSLocalizedString("comparedToLastWeek", comment: "")) \(abs(viewModel.pointPercentageDifference))%")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(viewModel.pointPercentageDifference >= 0 ? Color(.systemBlue) : Color(.systemRed))
                                
                                Spacer()
                                    .frame(height: 20)
                                
                                HStack(spacing: 16) {
                                    // 근력
                                    VStack {
                                        HStack {
                                            Image(systemName: "dumbbell.fill")
                                                .font(.system(size: 20))
                                                .padding(12)
                                                .background(.blue)
                                                .clipShape(Circle())
                                            Text("strength")
                                                .font(AppFont.subTitle)
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack(spacing: 4) {
                                            // progressbar 색상과 동일하게
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(viewModel.getStrenthCount() > 0 ?  Color(.blue) : Color.emptyColor)
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(viewModel.getStrenthCount() > 1 ?  Color(.blue) : Color.emptyColor)
                                        }
                                        .frame(height: 12)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            Text("\(viewModel.getStrenthCount())").font(AppFont.subTitle) + Text("/2").font(.subheadline)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.cellColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    // 운동 부하
                                    VStack {
                                        HStack {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 20))
                                                .padding(12)
                                                .background(.purple)
                                                .clipShape(Circle())
                                            Text("exerciseLoad")
                                                .font(AppFont.subTitle)
                                            Spacer()
                                        }
                                        ProgressView(value: viewModel.getWeekIntensityPercentage(viewModel.workoutData?.weekIntensity ?? ""))
                                            .progressViewStyle(.linear)
                                            .scaleEffect(y: 2.5)
                                            .frame(height: 20)
                                            .foregroundStyle(.blue)
                                        
                                        HStack {
                                            Text("insufficient")
                                            Spacer()
                                            Text("excessive")
                                        }
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        
                                        Spacer()
                                            .frame(height: 8)
                                        
                                        Text(viewModel.getIntensityText(viewModel.workoutData?.weekIntensity ?? ""))
                                            .font(.subheadline)
                                            .foregroundStyle(viewModel.getIntensityColor(viewModel.workoutData?.weekIntensity ?? ""))
                                    }
                                    .padding(12)
                                    .background(Color.cellColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            if showDatePicker {
                                CustomCalendarView(selectedDate: $viewModel.selectedDate, firstWorkoutDate: viewModel.firstWorkoutDate)
                                    .frame(height: 300)
                                    .background(Color.secondBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    MyWorkoutListView(viewModel: viewModel, selectedWorkout: $selectedWorkout)
                }
                .padding([.leading, .trailing, .bottom], sidePadding)
                .modifier(ScrollClipModifier())
                .scrollIndicators(.never)
            }
            .onAppear {
                viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
                viewModel.fetchFirstWorkoutDate(userId: 1)
            }
            .onChange(of: viewModel.selectedDate) {
                // 날짜 변경 시 주가 바뀌었을 때만 fetch
                guard let newWeek = viewModel.getStartAndEndOfWeek(from: $0), let oldWeek = viewModel.getStartAndEndOfWeek(from: $1), newWeek == oldWeek else {
                    viewModel.updateStartAndEndOfWeek()
                    showDatePicker = false
                    viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
                    return
                }
                showDatePicker = false
            }
            // 운동 추가 시 HomeView 업데이트 되도록
            .onChange(of: addModalManager.shouldUpdateHomeView) { newValue, oldValue in
                if newValue {
                    viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
                    viewModel.fetchFirstWorkoutDate(userId: 1)
                }
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
