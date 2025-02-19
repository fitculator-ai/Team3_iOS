//
//  SettingViewModel.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    @Published var heartRate: String = "40"
    @Published var isValid: Bool = true
    
    internal func validateHeartRate() -> Bool {
        if let intValue = Int(heartRate), intValue >= 40, intValue <= 120 {
            isValid = true
            return true
        } else {
            isValid = false
            return false
        }
    }
}
