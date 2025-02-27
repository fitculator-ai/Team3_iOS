import SwiftUI
import Features
import Shared

struct ContentView: View {
    @StateObject private var addModalManager = AddModalManager()
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .environmentObject(addModalManager)
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
                    Text("MY")
                }
            }
            .tint(Color.fitculatorLogo)
            
            Button(action: {
                addModalManager.isModalPresented.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .background(Color.white.opacity(0.8))
                    .foregroundStyle(Color.fitculatorLogo)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                    .padding(30)
            }
            .sheet(isPresented: $addModalManager.isModalPresented, onDismiss: {
                if addModalManager.shouldUpdateHomeView {
                    addModalManager.shouldUpdateHomeView = false
                }
            }) {
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
