//
//  HomeView.swift
//  Features
//
//  Created by 김영훈 on 2/14/25.
//

import SwiftUI
import UIKit

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
                        .font(.system(size: 20, weight: .bold))
                    Text(title)
                        .font(.system(size: 24, weight: .bold))
                        .italic()
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: rightIcon)
                    .font(.system(size: 20, weight: .bold))
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
    
    private let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // TODO: 배경색 변경
                Color.blue
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                       
                        HomeNavigationBar()
                        
                        HStack(spacing: 20) {
                            Spacer()
                            
                            Button(action: {
                                print("previous week")
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 18)
                                    .foregroundStyle(.white)
                            }
                            
                            // TODO: DatePicker 연결, 배경색 변경
                            Text("2025.02.02 ~ 2025.02.08")
                                .font(.subheadline)
                                .padding([.leading, .trailing], 24)
                                .padding([.top, .bottom], 8)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 36))
                                .onTapGesture {
                                    showDatePicker.toggle()
                                }
                            
                            Button(action: {
                                print("next week")
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
