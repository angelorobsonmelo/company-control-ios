import SwiftUI


struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ExpensesView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Expenses")
                }
                .tag(0)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Services")
                }
                .tag(1)
            
            ExpenseCategoryView()
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Expense Cat.")
                }
                .tag(2)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("Service Cat.")
                }
                .tag(3)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "5.square.fill")
                    Text("Balance")
                }
                .tag(4)
            
            SecondTabView()
                .tabItem {
                    Image(systemName: "6.square.fill")
                    Text("Logout")
                }
                .tag(5)
            
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
