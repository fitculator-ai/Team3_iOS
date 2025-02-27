//
//  BirthDatePickerSheetView.swift
//  Core
//
//  Created by Heeji Jung on 2/20/25.
//

import SwiftUI

struct BirthDatePickerSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var birthdate: String
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            Text("생년월일을 선택하세요")
                .font(.headline)
                .padding()
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .font(.headline)
                .onChange(of: selectedDate) { _,newDate in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    birthdate = formatter.string(from: newDate)
                }
            
            Spacer()
        }
        .padding()
        .onAppear {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: birthdate) {
                selectedDate = date
            }
        }
    }
}

