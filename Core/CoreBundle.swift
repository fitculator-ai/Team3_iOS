//
//  CoreBundle.swift
//  Fitculator
//
//  Created by Song Kim on 2/25/25.
//

import Foundation

public extension Bundle {
    static let core = Bundle.module
}

public func currentLanguage() -> String {
    return Locale.current.language.languageCode?.identifier ?? "Unknown"
}
