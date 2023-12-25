import SwiftUI

struct ContentView: View {
    @State private var isDarkMode = false
    
    var body: some View {
        TabView {
            LogsTabView()
                .tabItem {
                    VStack {
                        Text("Logs")
                        Image(systemName: "tray")
                    }
                }
                .tag(0)
            DashboardTabView()
                .tabItem {
                    VStack {
                        Text("Dashboard")
                        Image(systemName: "chart.pie")
                    }
                }
                .tag(1)
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .overlay(
            Button(action: {
                withAnimation {
                    isDarkMode.toggle()
                }
            }) {
                Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    .foregroundColor(.primary)
                    .imageScale(.large)
                    .padding()
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .padding()
            .shadow(radius: 5)
            , alignment: .bottom
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

