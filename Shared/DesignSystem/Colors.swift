//
//  Colors.swift
//  Shared
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI

public extension Color {
    final class BundleFinder {}
    static let background = Color("Background", bundle: Bundle(for: BundleFinder.self))
    static let cellColor = Color("CellColor", bundle: Bundle(for: BundleFinder.self))
    static let fitculatorLogo = Color("FitculatorLogo", bundle: Bundle(for: BundleFinder.self))
    
    static let subscriptionTagColor = Color("SubscriptionTagColor", bundle: Bundle(for: BundleFinder.self))
    static let editButtonColor = Color("EditButtonColor", bundle: Bundle(for: BundleFinder.self))
    
    static let basicColor = Color("BasicColor", bundle: Bundle(for: BundleFinder.self))
    static let disabledColor = Color("DisabledColor", bundle: Bundle(for: BundleFinder.self))
    static let emptyColor = Color("EmptyColor", bundle: Bundle(for: BundleFinder.self))
    
    static let calendarBackground = Color("CalendarBackground", bundle: Bundle(for: BundleFinder.self))
    
    static let textRed = Color("TextRed", bundle: Bundle(for: BundleFinder.self))
    static let textPurple = Color("TextPurple", bundle: Bundle(for: BundleFinder.self))
    static let textYellow = Color("TextYellow", bundle: Bundle(for: BundleFinder.self))
    static let textGreen = Color("TextGreen", bundle: Bundle(for: BundleFinder.self))
}

