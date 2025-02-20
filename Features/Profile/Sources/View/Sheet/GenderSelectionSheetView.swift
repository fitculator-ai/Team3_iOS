//
//  GenderSelectionSheetView.swift
//  Core
//
//  Created by Heeji Jung on 2/20/25.
//

import SwiftUI

//MARK: 프로필 선택 시트 뷰(성별)
struct GenderSettingSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedGender: String
    
    let genders = ["남성", "여성"]
    
     var body: some View {
        VStack {
            Text("성별을 선택하세요")
                .font(.headline)
                .padding()
            
            Picker("성별 선택", selection: $selectedGender) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender)
                }
            }
            .pickerStyle(WheelPickerStyle())
            Spacer()
        }
        .padding()
    }
}
