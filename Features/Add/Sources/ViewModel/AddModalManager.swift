//
//  AddModalManager.swift
//  Fitculator
//
//  Created by Song Kim on 2/18/25.
//

import SwiftUI

public class AddModalManager: ObservableObject {
    @Published public var isModalPresented: Bool = false
    public var shouldUpdateHomeView = false
    
    public init() {}
}

