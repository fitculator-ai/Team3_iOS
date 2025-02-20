import SwiftUI
import Features

struct ContentView: View {
    @StateObject private var addModalManager = AddModalManager()
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
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
                
                Text("커뮤니티")
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("커뮤니티")
                    }
                NavigationStack {
                    //NavigationLink(destination: ProfileView()) {
                        ProfileView()
                   // }
                }
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
                    .padding(30)
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
