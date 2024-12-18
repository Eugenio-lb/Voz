import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            // First Tab: ContentView
            ContentView()
                .tabItem {
                    Label("Record", systemImage: "mic.circle")
                }
            
            // Second Tab: SavedMemoView
            SavedMemoView()
                .tabItem {
                    Label("Saved Memos", systemImage: "list.bullet")
                }
        }
        .accentColor(.blue)  // Optional: Set tab bar accent color
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
