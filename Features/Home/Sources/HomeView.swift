//
//  HomeView.swift
//  Features
//
//  Created by 김영훈 on 2/14/25.
//

import SwiftUI
import UIKit
import Shared

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
                                ForEach(0...20, id: \.self) {_ in
                                    Image(systemName: "globe")
                                        .imageScale(.large)
                                        .foregroundStyle(.tint)
                                    Text("Hello, world!")
                                }
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
            .onChange(of: selectedDate) { _ in
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

#Preview {
    HomeView()
}
