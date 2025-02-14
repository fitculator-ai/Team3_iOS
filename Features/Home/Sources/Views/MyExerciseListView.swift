//
//  MyExerciseListView.swift
//  Features
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI
import Shared

struct MyExerciseListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("나의 운동 기록")
                .font(AppFont.mainTitle)
            
            ScrollView {
                LazyVStack {
                    ForEach(1...10, id: \.self) { _ in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                                .opacity(0.25)
                                .frame(width: UIScreen.main.bounds.width * 0.88, height: 160)
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
                                            .foregroundStyle(Color.white)
                                            .opacity(0.8)
                                    }
                                    Spacer()
                                    Text("111.1pt")
                                        .font(.system(size: 26))
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 30)
                                .padding(.bottom, 20)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("시간")
                                            .font(.system(size: 13))
                                            .foregroundStyle(Color.white)
                                            .opacity(0.8)
                                        Text("100min")
                                            .fontWeight(.semibold)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("평균 심박수")
                                            .font(.system(size: 13))
                                            .foregroundStyle(Color.white)
                                            .opacity(0.8)
                                        Text("150bpm")
                                            .fontWeight(.semibold)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("운동 강도")
                                            .font(.system(size: 13))
                                            .foregroundStyle(Color.white)
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
                }
            }
        }
        .padding()
    }
}

#Preview {
    MyExerciseListView()
}
