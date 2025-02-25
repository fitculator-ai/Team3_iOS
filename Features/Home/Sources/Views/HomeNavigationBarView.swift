//
//  HomeNavigationBarView.swift
//  Features
//
//  Created by 김영훈 on 2/19/25.
//

import SwiftUI
import UIKit
import Shared

// UINavigationController의 실제 높이를 가져오는 UIViewControllerRepresentable
struct NavigationBarHeightReader: UIViewControllerRepresentable {
    var onHeightUpdate: (CGFloat) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = viewController.navigationController {
                let height = navigationController.navigationBar.frame.height + viewController.view.safeAreaInsets.top
                onHeightUpdate(height)
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct HomeNavigationBar: View {
    final class BundleFinder {}
    var title: String = "Fitculator"
    var leftIcon: String = "globe"
    var rightIcon: String = "bell"

    @State private var navBarHeight: CGFloat = 44 // 기본값 설정

    var body: some View {
        HStack() {
            Image("LogoHorizontal", bundle: Bundle(for: BundleFinder.self))
                .resizable()
                // 이미지 여백 자르기
                .scaledToFill()
                .frame(width: navBarHeight * 5, height: navBarHeight)
                .offset(x: -navBarHeight * 0.5)
                .clipped()
            Spacer()
            
            Image(systemName: rightIcon)
                .font(AppFont.subTitle)
                .foregroundStyle(.white)
        }
        .frame(height: navBarHeight) // 동적으로 가져온 높이 적용
        
        NavigationBarHeightReader { height in
            self.navBarHeight = height
        }
    }
}

#Preview {
    HomeNavigationBar()
}
