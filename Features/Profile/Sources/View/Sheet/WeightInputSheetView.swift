//
//  WeightInputSheetView.swift
//  Core
//
//  Created by Heeji Jung on 2/20/25.
//

import SwiftUI

struct WeightSettingSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var Weight: Double
    
    private let maxFrontValue: Double = 200
    private let maxBackValue: Double = 9
    
    @State private var frontValue: Double = 70
    @State private var backValue: Double = 0
    
    init(Weight: Binding<Double>) {
          if Weight.wrappedValue.isNaN {
              _Weight = Weight
              _frontValue = State(initialValue: 0)
              _backValue = State(initialValue: 0)
          } else {
              _Weight = Weight
              _frontValue = State(initialValue: Weight.wrappedValue)
              _backValue = State(initialValue: 0)
          }
      }
    
    var body: some View {
        VStack {
            Text("몸무게를 입력하세요.")
                .font(.headline)
                .padding()
            
            HStack {
                Picker("Front Value", selection: $frontValue) {
                    ForEach(0...Int(maxFrontValue), id: \.self) { value in
                        Text("\(value)").tag(Double(value))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .onChange(of: frontValue) { newValue in
                    updateWeight()
                }
                
                Text(".")
                    .font(.headline)
                
                Picker("Back Value", selection: $backValue) {
                    ForEach(0...Int(maxBackValue), id: \.self) { value in
                        Text("\(value)").tag(Double(value))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .onChange(of: backValue) { newValue in
                    updateWeight()
                }
                
                Text("kg")
                    .font(.headline)
                    .padding()
            }
            .font(.headline)
            Spacer()
        }
        .padding()
    }
    
    private func updateWeight() {
        Weight = frontValue + (backValue * 0.1) // 소수점을 포함한 정확한 값으로 변환
    }
}
