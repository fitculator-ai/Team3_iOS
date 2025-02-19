//
//  MyWorkoutListView.swift
//  Features
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI
import Shared

public struct MyWorkoutListView: View {
    @State private var isActive: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("나의 운동 기록")
                    .font(AppFont.mainTitle)
                
                ScrollView {
                    LazyVStack {
                        ForEach(1...10, id: \.self) { _ in
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.cellColor)
                                    .frame(height: 160)
                                    .onTapGesture {
                                        isActive = true
                                    }
                                VStack {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.pink)
                                                .frame(width: 45, height: 45)
                                            Image(systemName: "figure.run")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("달리기")
                                                .font(AppFont.subTitle)
                                            Text("02.11 오후 6:50")
                                                .font(.system(size: 13))
                                                .opacity(0.8)
                                        }
                                        Spacer()
                                        Text("111.1pt")
                                            .font(.system(size: 26))
                                            .fontWeight(.bold)
                                    }
                                    .padding(.horizontal, 25)
                                    .padding(.bottom, 20)
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("시간")
                                                .font(.system(size: 13))
                                                .opacity(0.8)
                                            Text("100min")
                                                .fontWeight(.semibold)
                                        }
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            Text("평균 심박수")
                                                .font(.system(size: 13))
                                                .opacity(0.8)
                                            Text("150bpm")
                                                .fontWeight(.semibold)
                                        }
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            Text("운동 강도")
                                                .font(.system(size: 13))
                                                .opacity(0.8)
                                            Text("매우 높음")
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color.green)
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                }
                            }
                        }
                        .navigationDestination(isPresented: $isActive) {
                            MyWorkoutDetailView()
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.88)
        }
        .padding()
    }
}

#Preview {
    MyWorkoutListView()
}
