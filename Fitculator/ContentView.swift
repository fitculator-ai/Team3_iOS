//
//  ContentView.swift
//  Fitculator
//
//  Created by JIHYE SEOK on 2/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("홈화면입니다.")
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            Text("피드")
                .tabItem {
                    Image(systemName: "bubble")
                    Text("피드")
                }
            Text("+")
                .tabItem {
                    Image(systemName: "plus")
                }
            Text("커뮤니티")
                .tabItem {
                    Image(systemName: "person.2")
                    Text("커뮤니티")
                }
            Text("마이")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("마이")
                }
        }
        .font(.headline)
    }
}

#Preview {
    ContentView()
}
