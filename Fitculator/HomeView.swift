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
                            ForEach(0...20, id: \.self) {_ in
                                Image(systemName: "globe")
                                    .imageScale(.large)
                                    .foregroundStyle(.tint)
                                Text("Hello, world!")
                            }
                        }
                        .padding([.leading, .trailing, .bottom])
                    }
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
