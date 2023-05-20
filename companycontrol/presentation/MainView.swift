import SwiftUI


struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ExpenseCategoryView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
                .tag(0)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
                .tag(1)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
                .tag(2)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
                .tag(3)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
                .tag(4)
            
        }
    }
}

struct FirstTabView: View {
    var body: some View {
        NavigationView {
            Text("First Tab")
                .navigationBarTitle("First Tab", displayMode: .inline)
        }
    }
}

struct SecondTabView: View {
    var body: some View {
        NavigationView {
            Text("Second Tab")
                .navigationBarTitle("Second Tab", displayMode: .inline)
        }
    }
}



struct Content_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
