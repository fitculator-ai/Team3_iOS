//
//  GenderSelectionSheetView.swift
//  Core
//
//  Created by Heeji Jung on 2/20/25.
//

import SwiftUI

enum Gender: Int, CaseIterable, Identifiable {
    case man = 0
    case woman = 1

    var id: Int { rawValue }

    var description: String {
        switch self {
        case .man: return "남성"
        case .woman: return "여성"
        }
    }
    
    static func fromString(_ value: String) -> Gender? {
        switch value.uppercased() {
        case "MAN", "남성": return .man
        case "WOMAN", "여성": return .woman
        default: return nil
        }
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
                    Text(gender.description).tag(gender)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedGender) { newValue in
                print("선택된 성별: \(newValue.description)")
            }

            Spacer() 
        }
        .padding()
    }
}

