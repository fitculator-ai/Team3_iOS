//
//  HomeView.swift
//  Features
//
//  Created by 김영훈 on 2/14/25.
//

import SwiftUI
import UIKit
import Shared
import Charts

// UINavigationController의 실제 높이를 가져오는 UIViewControllerRepresentable
struct NavigationBarHeightReader: UIViewControllerRepresentable {
    var onHeightUpdate: (CGFloat) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = viewController.navigationController {
                let height = navigationController.navigationBar.frame.height + viewController.view.safeAreaInsets.top
                onHeightUpdate(height)
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct HomeNavigationBar: View {
    var title: String = "Fitculator"
    var leftIcon: String = "globe"
    var rightIcon: String = "bell"

    @State private var navBarHeight: CGFloat = 44 // 기본값 설정

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: leftIcon)
                        .font(AppFont.subTitle)
                    Text(title)
                        .font(AppFont.mainTitle)
                        .italic()
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: rightIcon)
                    .font(AppFont.subTitle)
                    .foregroundStyle(.white)
            }
            .frame(height: navBarHeight) // 동적으로 가져온 높이 적용

            NavigationBarHeightReader { height in
                self.navBarHeight = height
            }
        }
    }
}

public struct HomeView: View {
    public init(selectedDate: Date = Date(), showDatePicker: Bool = false) {
        self.selectedDate = selectedDate
        self.showDatePicker = showDatePicker
    }
    
    // 주의 첫날과 마지막날 날짜 구하기
    private func getStartAndEndOfWeek(from date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return nil
        }
        
        if let endOfWeek = calendar.date(byAdding: .day, value: 6, to: weekInterval.start) {
            return (weekInterval.start, endOfWeek)
        } else {
            return nil
        }
    }
    
    // 주의 첫날과 마지막날 날짜 업데이트
    private func updateStartAndEndOfWeek() {
        if let (startOfWeek, endOfWeek) = self.getStartAndEndOfWeek(from: selectedDate) {
            self.startOfWeek = startOfWeek
            self.endOfWeek = endOfWeek
        }
    }
    
    // Date yyyy-MM-dd 형식으로 바꾸기
    private func getStringFromDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    private let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
    @State private var selectedDate = Date()
    @State private var startOfWeek = Date()
    @State private var endOfWeek = Date()
    @State private var showDatePicker = false
    
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
                                if let previousWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) {
                                    selectedDate = previousWeekDate
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                                    .foregroundStyle(.white)
                            }
                            
                            // TODO: 너비 고정
                            Text("\(getStringFromDate(from: startOfWeek)) ~ \(getStringFromDate(from: endOfWeek))")
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
                                if let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: +1, to: selectedDate) {
                                    selectedDate = nextWeekDate
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
                                ExercisePieChartView(data: ExercisePoint.dummyData())
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7)
                            }
                            if showDatePicker {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
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
                updateStartAndEndOfWeek()
            }
            .onChange(of: selectedDate) {
                updateStartAndEndOfWeek()
                showDatePicker = false
            }
        }
    }
}

// SafeArea 밖으로 스크롤 뷰가 뻗는 것 방지
struct ScrollClipModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Rectangle())
    }
}

struct ExercisePoint {
    //TODO: enum 변경
    let exerciseType: String
    let point: Int
    
    static func dummyData() -> [ExercisePoint] {
        return [
            ExercisePoint(exerciseType: "달리기", point: 81),
            ExercisePoint(exerciseType: "HIIT", point: 81),
//            ExercisePoint(exerciseType: "수영", point: 22)
        ]
    }
}

//TODO: 차트 색상 변경, info 버튼, 아이콘 추가
struct ExercisePieChartView: View {
    let exerciseIcons: [String: String] = [
        "달리기": "figure.run",
        "HIIT": "bolt.fill",
        "수영": "figure.open.water.swim"
    ]
    var data: [ExercisePoint]
    
    var body: some View {
        Chart(data, id: \.exerciseType) { element in
            SectorMark(angle: .value("Usage", element.point), innerRadius: .ratio(0.5))
                .foregroundStyle(by: .value("Version", element.exerciseType))
                .annotation(position: .overlay) {
                    if let exerciseIcon = exerciseIcons[element.exerciseType] {
                        GeometryReader { geometry in
                            let frame = geometry.frame(in: .local)
                            // 여기 수정해야 해당 영역의 각도
                            let centerAngle = .pi * (Double(element.point) / Double(data.reduce(0) { $0 + $1.point }))
                            let radius: CGFloat = min(frame.width, frame.height) / 2
                            let ratio = 0.1
                            
                            let offsetX = radius * cos(centerAngle - .pi / 2) * ratio
                            let offsetY = radius * sin(centerAngle - .pi / 2) * ratio
                            
                            Image(systemName: exerciseIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .position(x: frame.midX - offsetX, y: frame.midY + offsetY)
                        }
                    }
                }
        }
        .chartLegend(.hidden)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                let frame = geometry[chartProxy.plotFrame!]
                VStack() {
                    Text("유산소")
                        .font(.subheadline)
                    Text("80").font(.largeTitle) + Text(" %").font(.subheadline)
                    Spacer().frame(height: 4)
                    Button(action: {
                        print("info")
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.white)
                            .font(.caption)
                    }
                }
                .position(x: frame.midX, y: frame.midY)
                .offset(x: 0, y: frame.height * 0.03)
            }
        }
        .padding()
        .scaledToFit()
    }
}

#Preview {
    HomeView()
}
