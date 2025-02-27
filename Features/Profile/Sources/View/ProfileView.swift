//
//  ProfileView.swift
//  Features
//
//  Created by Heeji Jung on 2/14/25.
//

import SwiftUI
import Charts
import Shared
import Core

public struct ProfileView: View {
    public init() {}
    @StateObject private var profileviewModel = ProfileViewModel()
    @StateObject private var chartviewModel = ProfileChartViewModel()
    
    var followingCount: Int = 0
    var followerCount: Int = 0
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Spacer()
                            Image(uiImage: profileviewModel.profileImage ?? UIImage(named: "person.circle.fill") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 5)
                                .padding(.leading, 5)
                            Spacer()
                        }
                        
                        VStack(alignment: .center) {
                            HStack {
                                Text(profileviewModel.MyPageRecord?.userName ?? "user")
                                    .font(AppFont.profileItemFont)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.basicColor)
                                
                                Capsule(style: .continuous)
                                    .fill(.blue)
                                    .frame(width: 70, height: 30)
                                    .overlay(
                                        Text("PRO")
                                            .font(AppFont.profileContentTextFont)
                                            .foregroundColor(.white)
                                    )
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        HStack {
                            HStack(alignment: .center, spacing: 10) {
                                Text("팔로워 \(followerCount)")
                                    .font(AppFont.profileContentTextFont)
                                    .foregroundColor(.white)
                                
                                Divider()
                                    .frame(height: 20)
                                    .background(Color.white)
                                
                                Text("팔로잉 \(followingCount)")
                                    .font(AppFont.profileContentTextFont)
                                    .foregroundColor(.white)
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
                            .frame(width: 180)
                            
                            NavigationLink(destination: ProfileEditView().environmentObject(profileviewModel))  {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.editButtonColor)
                                    .frame(width: 100, height: 40)
                                    .overlay(
                                        Text("프로필 편집")
                                            .foregroundColor(.basicColor)
                                            .font(AppFont.profileContentTextFont)
                                    )
                            }
                        }
                        .padding([.leading, .trailing], 30)
                        
                        Divider()
                            .background(Color.basicColor)
                            .frame(height: 30)
                            .padding(.horizontal, 0)
                        
                        VStack(alignment: .leading) {
                            Text("주간 운동량")
                                .font(AppFont.subTitle)
                            
                            WeeklyActivityChart()
                                .environmentObject(chartviewModel)
                            
                            Spacer()
                                .frame(height: 50)
                            
                            Text("피로도 그래프")
                                .font(AppFont.subTitle)
                            FatigueChart()
                                .environmentObject(chartviewModel)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.88)
                    .frame(maxHeight: .infinity)
                }
                .navigationTitle("MY")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingView().environmentObject(profileviewModel)) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.basicColor)
                                .padding(.trailing, 5)
                        }
                    }
                }
            }
            .onAppear{
                profileviewModel.fetchMyPage(userId: 1)
                profileviewModel.fetchProfileImage(userId: 1)
            }
            .environmentObject(profileviewModel)
        }.scrollIndicators(.never)
    }
}

public struct WeeklyActivityChart: View {
    @EnvironmentObject var viewModel: ProfileChartViewModel
    
    @State private var showDatePicker = false
    @State private var selectedWorkout: WorkoutRecord?
    private let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
    
    public var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                if let previousWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: viewModel.selectedDate) {
                                    viewModel.selectedDate = previousWeekDate
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                            }
                            
                            Text(viewModel.getSelectedWeekString())
                                .font(.subheadline)
                                .fontWeight(["이번주 운동량", "지난주 운동량"].contains(viewModel.getSelectedWeekString()) ? .semibold : .regular)
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
                            }
                            .disabled(viewModel.getSelectedWeekString() == "이번주 운동량")
                            
                            Spacer()
                        }
                        
                        VStack {
                            ZStack{
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .basicColor))
                                        .scaleEffect(1.5)
                                        .padding()
                                } else if (viewModel.workoutData?.records ?? []).isEmpty && viewModel.weeklyWorkoutData.isEmpty {
                                    Text("운동을 추가해 그래프를 분석해보세요!")
                                        .font(.headline)
                                        .foregroundColor(.basicColor)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.5)))
                                        .padding()
                                } else {
                                    
                                    let combinedData: [WorkoutRecord] = {
                                        // workoutData와 weeklyWorkoutData의 records를 합침
                                        let workoutDataRecords = viewModel.workoutData?.records ?? []
                                        let weeklyWorkoutDataRecords = viewModel.weeklyWorkoutData.flatMap { $0.records }
                                        
                                        // 만약 두 데이터가 중복되지 않는다면, 결합
                                        return workoutDataRecords + weeklyWorkoutDataRecords
                                    }()
                                    
                                    // Chart에 데이터 전달
                                    Chart {
                                        ForEach(combinedData, id: \.id) { record in
                                            let recordDate = record.recordStart
                                            let intensityLevel = ExerciseIntensityColor.from(record.intensity)
                                            let intensityValue = intensityLevel.intensityValue
                                            
                                            BarMark(
                                                x: .value("Date", recordDate),  // recordDate를 x 값으로 사용
                                                y: .value("Intensity", intensityValue)  // Intensity를 y 값으로 사용
                                            )
                                            .foregroundStyle(intensityLevel.color)  // 해당 강도에 맞는 색상 사용
                                        }
                                    }
                                    .frame(height: 300)
                                    .padding(.horizontal, 8)
                                }
                            }
                            
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
            }
            .onChange(of: viewModel.selectedDate) {
                viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
            }
        }
    }
}
        
public struct FatigueChart: View {
    @EnvironmentObject var viewModel: ProfileChartViewModel
    
    @State private var showDatePicker = false
    @State private var selectedWorkout: WorkoutRecord?
    private let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
    
    public var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .basicColor))
                                    .scaleEffect(1.5)
                                    .padding()
                            } else if (viewModel.workoutData?.records ?? []).isEmpty && viewModel.weeklyWorkoutData.isEmpty {
                                Text("운동을 추가해 그래프를 분석해보세요!")
                                    .font(.headline)
                                    .foregroundColor(.basicColor)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.5)))
                                    .padding()
                            } else {
                                let workoutDataRecords = viewModel.workoutData?.records ?? []
                                let weeklyWorkoutDataRecords = viewModel.weeklyWorkoutData.flatMap { $0.records }
                                let combinedData = workoutDataRecords + weeklyWorkoutDataRecords

                                let lineData: [(Date, Double)] = combinedData
                                    .map { record -> (Date, Double)? in
                                        guard let date = DateFormatterUtil.dateFormatTime.date(from: record.recordStart) else {
                                            print("날짜 변환 실패: \(record.recordStart)")
                                            return nil
                                        }
                                        return (date, ExerciseIntensityColor.from(record.intensity).intensityValue) as? (Date, Double)
                                    }
                                    .compactMap { $0 }
                                
                                Chart {
                                    ForEach(lineData, id: \.0) { data in
                                        LineMark(
                                            x: .value("Date", data.0, unit: .day), // ✅ Date 값 올바르게 사용
                                            y: .value("Intensity", data.1)
                                        )
                                        .foregroundStyle(Color.blue)
                                        .lineStyle(.init(lineWidth: 2))
                                    }
                                }
                                .frame(height: 300)
                                .padding(.horizontal, 8)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
            }
            .onChange(of: viewModel.selectedDate) {
                viewModel.fetchWeeklyWorkout(userId: 1, targetDate: viewModel.getSelectedDateString())
            }
        }
    }
}
#Preview {
    ProfileView()
}
