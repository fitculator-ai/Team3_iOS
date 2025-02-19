//
//  HomeView.swift
//  Features
//
//  Created by 김영훈 on 2/14/25.
//

import SwiftUI
import UIKit
import Shared

public struct HomeView: View {
    public init() {}
    @StateObject private var viewModel = HomeViewModel()
    @State private var showDatePicker = false
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
                            
                            // TODO: 조건에 따라 버튼 disabled 처리
                            Button(action: {
                                if let previousWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: viewModel.selectedDate) {
                                    viewModel.selectedDate = previousWeekDate
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                                    .foregroundStyle(.white)
                            }
                            
                            // TODO: 너비 고정
                            Text(viewModel.getSelectedWeekString())
                                .font(.subheadline)
                                .padding([.leading, .trailing], 24)
                                .padding([.top, .bottom], 8)
                                .background(Color.cellColor)
                                .clipShape(RoundedRectangle(cornerRadius: 36))
                                .onTapGesture {
                                    showDatePicker.toggle()
                                }
                            
                            // TODO: 조건에 따라 버튼 disabled 처리
                            Button(action: {
                                if let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: +1, to: viewModel.selectedDate) {
                                    viewModel.selectedDate = nextWeekDate
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                        }
                        ZStack(alignment: .top) {
                            VStack {
                                ExercisePieChartView(data: viewModel.weeklyExercisePoints)
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7)
                                
                                HStack {
                                    Image(systemName: "arrowshape.down.circle")
                                    Text("지난 주 대비 19%")
                                }
                                .font(.subheadline)
                                
                                Spacer()
                                    .frame(height: 20)
                                
                                //TODO: 색상 변경
                                HStack(spacing: 16) {
                                    // 근력
                                    VStack {
                                        HStack {
                                            Image(systemName: "dumbbell.fill")
                                                .font(.system(size: 20))
                                                .padding(12)
                                                .background(.blue)
                                                .clipShape(Circle())
                                            Text("근 력")
                                                .font(AppFont.subTitle)
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack(spacing: 4) {
                                            RoundedRectangle(cornerRadius: 8)
                                            RoundedRectangle(cornerRadius: 8)
                                        }
                                        .foregroundStyle(.blue)
                                        .frame(height: 12)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            Text(viewModel.getStrenthPoint()).font(AppFont.subTitle) + Text("/2").font(.subheadline)
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
                                            Text("운동 부하")
                                                .font(AppFont.subTitle)
                                            Spacer()
                                        }
                                        ProgressView(value: viewModel.getWorkoutLoad())
                                            .progressViewStyle(.linear)
                                            .scaleEffect(y: 2.5)
                                            .frame(height: 20)
                                            .foregroundStyle(.blue)
                                        
                                        HStack {
                                            Text("부족")
                                            Spacer()
                                            Text("과다")
                                        }
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        
                                        Spacer()
                                            .frame(height: 8)
                                        
                                        Text("적당한 운동중")
                                            .font(.subheadline)
                                    }
                                    .padding(12)
                                    .background(Color.cellColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            if showDatePicker {
                                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .labelsHidden()
                                // TODO: Calendar 디자인 변경
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 5)
                            }
                        }
                    }
                }
                .padding([.leading, .trailing, .bottom], sidePadding)
                .modifier(ScrollClipModifier())
                .scrollIndicators(.never)
            }
            .onAppear {
                viewModel.updateStartAndEndOfWeek()
            }
            .onChange(of: viewModel.selectedDate) {
                viewModel.updateStartAndEndOfWeek()
                showDatePicker = false
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
