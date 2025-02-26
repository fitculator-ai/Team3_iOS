//
//  currentLanguage.swift
//  Fitculator
//
//  Created by Song Kim on 2/26/25.
//

import Foundation

public func currentLanguage() -> String {
    let preferredLanguage = Locale.preferredLanguages.first ?? "Unknown"
    return preferredLanguage
}
