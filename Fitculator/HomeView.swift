//
//  HomeView.swift
//  Fitculator
//
//  Created by 김영훈 on 2/11/25.
//

import SwiftUI

struct HomeNavigationBar: View {
    var title: String = "Fitculator"
    var leftIcon: String = "globe"
    var rightIcon: String = "bell"
    
    var body: some View {
        HStack {
            HStack {
                // TODO: Logo 변경
                Image(systemName: leftIcon)
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .italic()
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Image(systemName: rightIcon)
                .foregroundStyle(.white)
        }
    }
}

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // TODO: 배경색 변경
                Color.blue
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        // TODO: NavigationBar 크기 조정
                        HomeNavigationBar()
                        
                        HStack(spacing: 20) {
                            Spacer()
                            
                            Button(action: {
                                print("previous week")
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                    .foregroundStyle(.white)
                            }
                            
                            // TODO: DatePicker 연결, 배경색 변경
                            Text("2025.02.02 ~ 2025.02.08")
                                .font(.system(size: 16))
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
                                    .frame(width: 12, height: 20)
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
                .padding([.leading, .trailing, .bottom])
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
