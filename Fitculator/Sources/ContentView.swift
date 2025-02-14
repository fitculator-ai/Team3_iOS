import SwiftUI
import Features

struct ContentView: View {
    @State private var isModalPresented = false

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
                
                Text("마이")
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("마이")
                    }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isModalPresented.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .sheet(isPresented: $isModalPresented) {
//                        ExerciseListView()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
  ContentView()
}
