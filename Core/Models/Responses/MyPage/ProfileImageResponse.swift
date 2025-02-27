//
//  ProfileImage.swift
//  Core
//
//  Created by Heeji Jung on 2/24/25.
//

import Foundation

public struct ProfileImageResponse: Codable {
    public let success: Bool
    public let message: String
    public var data: String
}
