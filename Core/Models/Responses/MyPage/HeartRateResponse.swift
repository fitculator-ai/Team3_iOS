//
//  HeartRateResponse.swift
//  Features
//
//  Created by Heeji Jung on 2/21/25.
//

import Foundation

public struct HeartRateResponse: Codable {
    public var success: Bool
    public var message: String
    public var data: String
}
