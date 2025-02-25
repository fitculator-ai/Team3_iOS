//
//  ExercisePieChartView.swift
//  Features
//
//  Created by 김영훈 on 2/19/25.
//

import SwiftUI
import Charts

struct WorkoutRecordPointSum {
    let exerciseKorName: String
    let exerciseImg: String?
    let recordPointSum: Double
    let exerciseColor: Color
    
    static func dummyData() -> [WorkoutRecordPointSum] {
        return [
            WorkoutRecordPointSum(exerciseKorName: "달리기", exerciseImg: "figure.run", recordPointSum: 50, exerciseColor: .red),
            WorkoutRecordPointSum(exerciseKorName: "HIIT", exerciseImg: "bolt.fill", recordPointSum: 50, exerciseColor: .blue),
            WorkoutRecordPointSum(exerciseKorName: "수영", exerciseImg: "figure.open.water.swim", recordPointSum: 50, exerciseColor: .green),
            WorkoutRecordPointSum(exerciseKorName: "테니스", exerciseImg: "figure.tennis", recordPointSum: 50, exerciseColor: .orange),
        ]
    }
}

struct ExercisePieChartView: View {
    // info button 최초 한번만 뜨게 하기 위함
    @AppStorage("hasSeenInfoButton") private var hasSeenInfoButton: Bool = false
    @State private var updateHasSeenInfoButton: Bool = false
    @State private var showPopover = false
    var data: [WorkoutRecordPointSum]
    var total: Double {
        data.reduce(0) { $0 + $1.recordPointSum }
    }
    var adjustedData: [WorkoutRecordPointSum] {
        if total < 100 {
            let remaining = 100 - total
            return data + [WorkoutRecordPointSum(exerciseKorName: "empty", exerciseImg: nil, recordPointSum: remaining, exerciseColor: Color.cellColor)]
        }
        return data
    }
    
    var cumulativeSums: [Double] {
        var sums: [Double] = []
        var sum: Double = 0
        for point in adjustedData {
            sum += Double(point.recordPointSum)
            sums.append(sum)
        }
        return sums
    }
    
    var body: some View {
        Chart(Array(zip(adjustedData, cumulativeSums)), id: \.0.exerciseKorName) { element, cumulativeSum in
            let elementPoint = Double(element.recordPointSum)
            let adjustedTotal = max(total, 100)
            let centerAngle =
            // 현재 조각의 끝 지점
                .pi * 2 * (cumulativeSum / adjustedTotal)
            // 조각 중심으로 보정
            - (.pi * elementPoint / adjustedTotal)
            // 시작점을 12시 방향으로 조정 (기본값 3시)
            - .pi / 2
            
            SectorMark(angle: .value("Point", elementPoint), innerRadius: .ratio(0.5))
                .foregroundStyle(element.exerciseColor)
                .annotation(position: .overlay) {
                    GeometryReader { geometry in
                        // 아이콘 원 안쪽으로 이동
                        let frame = geometry.frame(in: .local)
                        let radius: CGFloat = min(frame.width, frame.height) / 2
                        let ratio: CGFloat = 0.1
                        
                        let offsetX = radius * cos(centerAngle) * ratio
                        let offsetY = radius * sin(centerAngle) * ratio
                        
                        if let exerciseImg = element.exerciseImg {
                            Image(systemName: exerciseImg)
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
        .chartOverlay { chartProxy in
            GeometryReader { geometry in
                if let plotFrame = chartProxy.plotFrame {
                    let frame = geometry[plotFrame]
                    VStack {
                        Text("유산소")
                            .font(.subheadline)
                        Text("\(Int(total))").font(.largeTitle) + Text(" %").font(.subheadline)
                        if !hasSeenInfoButton {
                            Spacer().frame(height: 4)
                            Button(action: {
                                showPopover.toggle()
                                updateHasSeenInfoButton = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.white)
                                    .font(.caption)
                            }
                            .popover(isPresented: $showPopover, arrowEdge: .top) {
                                Text("세계보건기구 신체활동 가이드라인 기준\n나의 주간 운동량입니다.")
                                    .font(.caption)
                                    .padding([.leading, .trailing], 10)
                                    .presentationBackground(.gray.opacity(0.3))
                                    .presentationCompactAdaptation(.popover)
                            }
                        }
                    }
                    .position(x: frame.midX, y: frame.midY)
                    .offset(x: 0, y: frame.height * 0.03)
                }
            }
        }
        .padding()
        .scaledToFit()
        .onDisappear {
            if updateHasSeenInfoButton {
                hasSeenInfoButton = true
            }
        }
    }
}
