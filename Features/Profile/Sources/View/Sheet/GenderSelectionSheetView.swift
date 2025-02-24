//
//  GenderSelectionSheetView.swift
//  Core
//
//  Created by Heeji Jung on 2/20/25.
//

import SwiftUI

enum Gender: Int, CaseIterable, Identifiable {
    case male = 0
    case female = 1
    
    var id: Int { rawValue }
    
    var description: String {
        switch self {
        case .male: return "남성"
        case .female: return "여성"
        }
    }
    
    static func fromString(_ string: String) -> Gender {
        switch string {
        case "남성":
            return .male
        case "여성":
            return .female
        default:
            return .male
        }
    }
    
    static func fromInt(_ value: Int) -> Gender {
        return Gender(rawValue: value) ?? .male
    }
}

//MARK: 프로필 선택 시트 뷰(성별)
struct GenderSettingSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedGender: Gender
    
     var body: some View {
        VStack {
            Text("성별을 선택하세요")
                .font(.headline)
                .padding()
            
            Picker("성별 선택", selection: $selectedGender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.description)
                }
            }
            .pickerStyle(WheelPickerStyle())
            Spacer()
        }
        .padding()
    }
}

