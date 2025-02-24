//
//  ScrollClipModifier.swift
//  Shared
//
//  Created by 김영훈 on 2/19/25.
//

import SwiftUI

// SafeArea 밖으로 스크롤 뷰가 뻗는 것 방지
public struct ScrollClipModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .clipShape(Rectangle())
    }
}
