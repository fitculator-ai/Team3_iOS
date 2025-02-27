import SwiftUI

@main
struct FitculatorApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
