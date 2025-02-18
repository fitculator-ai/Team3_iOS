import SwiftUI
import Features

struct ContentView: View {
    @StateObject private var addModalManager = AddModalManager()
    
    var body: some View {
        ZStack {
            TabView {
                Text("홈화면")
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                
                Text("피드")
                    .tabItem {
                        Image(systemName: "bubble")
                        Text("피드")
                    }
                
                Text("")
                    .tabItem {
                        Text("")
                    }
                    .allowsHitTesting(true)
                
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
            
            Button(action: {
                addModalManager.isModalPresented.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .sheet(isPresented: $addModalManager.isModalPresented) {
                AddExerciseListView()
                    .environmentObject(addModalManager)
            }
            .offset(x: 0, y: (UIScreen.main.bounds.height/2)-74)
        }
    }
}


#Preview {
    ContentView()
}
