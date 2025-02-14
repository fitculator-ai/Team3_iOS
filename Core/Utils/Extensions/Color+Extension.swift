//
//  Color+Extension.swift
//  Fitculator
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI

// MARK: hex color 값 사용
// 사용예시 - Color("hex: #FFFFFF")
public extension Color {  // <- public 추가
    init(hex: String, opacity: Double = 1.0) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: opacity)
    }
}
