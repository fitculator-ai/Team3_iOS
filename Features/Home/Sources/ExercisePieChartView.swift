//
//  ExercisePieChartView.swift
//  Features
//
//  Created by 김영훈 on 2/19/25.
//

import SwiftUI
import Charts

struct ExercisePoint {
    //TODO: enum 변경
    let exerciseType: String
    let point: Double
    
    static func dummyData() -> [ExercisePoint] {
        return [
            ExercisePoint(exerciseType: "달리기", point: 50),
            ExercisePoint(exerciseType: "HIIT", point: 50),
            ExercisePoint(exerciseType: "수영", point: 50),
            ExercisePoint(exerciseType: "테니스", point: 50),
        ]
    }
}

//TODO: 운동 종류 추가, 색상 변경, info 버튼
struct ExercisePieChartView: View {
    let exerciseIcons: [String: String] = [
        "달리기": "figure.run",
        "HIIT": "bolt.fill",
        "수영": "figure.open.water.swim",
        "테니스": "figure.tennis",
    ]
    let exerciseColors: [String: Color] = [
        "달리기": .red,
        "HIIT": .blue,
        "수영": .green,
        "테니스": .orange,
        "empty": Color.cellColor
    ]
    var data: [ExercisePoint]
    var total: Double {
        data.reduce(0) { $0 + $1.point }
    }
    var adjustedData: [ExercisePoint] {
        //TODO: maximum point 변경
        if total < 250 {
            let remaining = 250 - total
            return data + [ExercisePoint(exerciseType: "empty", point: remaining)]
        }
        return data
    }

    var cumulativeSums: [Double] {
        var sums: [Double] = []
        var sum: Double = 0
        for point in adjustedData {
            sum += Double(point.point)
            sums.append(sum)
        }
        return sums
    }

    var body: some View {
        Chart(Array(zip(adjustedData, cumulativeSums)), id: \.0.exerciseType) { element, cumulativeSum in
            let elementPoint = Double(element.point)
            //TODO: maximum point 변경
            let adjustedTotal = max(total, 250)
            let centerAngle =
                // 현재 조각의 끝 지점
                .pi * 2 * (cumulativeSum / adjustedTotal)
                // 조각 중심으로 보정
                - (.pi * elementPoint / adjustedTotal)
                // 시작점을 12시 방향으로 조정 (기본값 3시)
                - .pi / 2

            SectorMark(angle: .value("Point", elementPoint), innerRadius: .ratio(0.5))
                .foregroundStyle(exerciseColors[element.exerciseType] ?? Color.cellColor)
                .annotation(position: .overlay) {
                    if let exerciseIcon = exerciseIcons[element.exerciseType] {
                        GeometryReader { geometry in
                            // 아이콘 원 안쪽으로 이동
                            let frame = geometry.frame(in: .local)
                            let radius: CGFloat = min(frame.width, frame.height) / 2
                            let ratio: CGFloat = 0.1

                            let offsetX = radius * cos(centerAngle) * ratio
                            let offsetY = radius * sin(centerAngle) * ratio

                            Image(systemName: exerciseIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .position(x: frame.midX - offsetX, y: frame.midY - offsetY)
                        }
                    }
                }
        }
        .chartLegend(.hidden)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                let frame = geometry[chartProxy.plotFrame!]
                VStack {
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
