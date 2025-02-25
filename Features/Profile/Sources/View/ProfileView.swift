//
//  ProfileView.swift
//  Features
//
//  Created by Heeji Jung on 2/14/25.
//

import SwiftUI
import Charts
import Shared

//임시
enum ExerciseIntensity: String, CaseIterable {
    case veryLow = "매우 낮음"
    case low = "낮음"
    case medium = "중간"
    case high = "높음"
    case veryHigh = "매우 높음"
    
    var color: Color {
        switch self {
        case .veryLow: return .blue
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        }
    }
}

//임시
struct Exercise: Identifiable {
    let id: Int
    let weeklyPercentage: [String: [ExerciseIntensity: Double]]
}

//임시
struct ExerciseData {
    static let exercises: [Exercise] = [
        Exercise(id: 1, weeklyPercentage: [
            "월요일": [.veryLow: 10, .low: 10, .medium: 30, .high: 35, .veryHigh: 5],
            "화요일": [.veryLow: 15, .low: 25, .medium: 25, .high: 20, .veryHigh: 5],
            "수요일": [.veryLow: 20, .low: 30, .medium: 20, .high: 15, .veryHigh: 5],
            "목요일": [.veryLow: 20, .low: 20, .medium: 20, .high: 10, .veryHigh: 0],
            "금요일": [.veryLow: 25, .low: 25, .medium: 10, .high: 10, .veryHigh: 5],
            "토요일": [.veryLow: 30, .low: 20, .medium: 10, .high: 5, .veryHigh: 0],
            "일요일": [.veryLow: 25, .low: 20, .medium: 15, .high: 10, .veryHigh: 5]
        ])
    ]
}

public struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var followingCount: Int = 0
    var followerCount: Int = 0
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Spacer()
                            Image(uiImage: viewModel.profileImage ?? UIImage(named: "person.circle.fill") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 5)
                                .padding(.leading, 5)
                            Spacer()
                        }
                        .padding(.top, -50)
                        
                        VStack(alignment: .center) {
                            HStack {
                                Text(viewModel.MyPageRecord?.userName ?? "테스트")
                                    .font(AppFont.profileItemFont)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
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
                            
                            NavigationLink(destination: ProfileEditView().environmentObject(viewModel))  {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.editButtonColor)
                                    .frame(width: 100, height: 40)
                                    .overlay(
                                        Text("프로필 편집")
                                            .foregroundColor(.white)
                                            .font(AppFont.profileContentTextFont)
                                    )
                            }
                        }
                        .padding([.leading, .trailing], 30)
                        
                        Divider()
                            .background(Color.white)
                            .frame(height: 30)
                            .padding(.horizontal, 0)
                        
                        VStack(alignment: .leading) {
                            Text("주간 운동량")
                                .font(AppFont.mainTitle)
                            WeeklyActivityChart()
                            
                            Spacer()
                                .frame(height: 50)
                            
                            Text("피로도 그래프")
                                .font(AppFont.mainTitle)
                            FatigueChart()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.88)
                    .frame(maxHeight: .infinity)
                }
                .navigationTitle("마이")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: NavigationLink(destination: SettingView().environmentObject(ProfileViewModel())) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding(.trailing, 5)
                })
            }
            .onAppear{
                viewModel.fetchMyPage(userId: 1)
                viewModel.fetchProfileImage(userId: 1)
            }
            .environmentObject(viewModel)
        }.scrollIndicators(.never)
    }
}
struct WeeklyActivityChart: View {
    let daysOfWeek = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(ExerciseData.exercises) { exercise in
                    VStack(alignment: .leading) {
                        ZStack {
                            // 그래프 배경 (블러 처리)
                            Chart {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    if let percentages = exercise.weeklyPercentage[day] {
                                        ForEach(percentages.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                                            if let value = percentages[type] {
                                                BarMark(
                                                    x: .value("Day", day),
                                                    y: .value(type.rawValue, value)
                                                )
                                                .foregroundStyle(by: .value("Type", type.rawValue))
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 250)
                            .padding()
                            .blur(radius: 10)

                            // 운동 추가 문구
                            VStack {
                                Spacer()
                                Text("그래프를 확인해보세요!\n운동을 추가하여 분석을 확인할 수 있습니다.")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.5)))
                                    .padding()
                            }
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct FatigueChart: View {
    let daysOfWeek = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(ExerciseData.exercises) { exercise in
                    VStack(alignment: .leading) {
                        ZStack {
                            // 그래프 배경 (블러 처리)
                            Chart {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    if let percentages = exercise.weeklyPercentage[day] {
                                        let totalPercentage = calculateTotalExercisePercentage(for: percentages)
                                        
                                        // Bar chart
                                        BarMark(
                                            x: .value("Day", day),
                                            y: .value("Total", totalPercentage)
                                        )
                                        .foregroundStyle(Color.blue)
                                        
                                        // Line chart
                                        LineMark(
                                            x: .value("Day", day),
                                            y: .value("Total", totalPercentage)
                                        )
                                        .foregroundStyle(Color.red)
                                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                                        .symbol(.circle)
                                        .symbolSize(10)
                                    }
                                }
                            }
                            .frame(height: 300)
                            .padding()
                            .blur(radius: 15)

                            VStack {
                                Spacer()
                                Text("그래프를 확인해보세요!\n운동을 추가하여 분석을 확인할 수 있습니다.")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.5)))
                                    .padding()
                            }
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func calculateTotalExercisePercentage(for percentages: [ExerciseIntensity: Double]) -> Double {
        let total = percentages.values.reduce(0, +)
        return total
    }
}

#Preview {
    ProfileView()
}
