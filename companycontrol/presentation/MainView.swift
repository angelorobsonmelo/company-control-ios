import SwiftUI


struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ExpensesView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
                .tag(0)
            
            ServicesView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Services")
                }
                .tag(1)
            
            CategoryView()
                .tabItem {
                    Image(systemName: "square.stack")
                    Text("Categories")
                }
                .tag(2)
            
            CompanyView()
                .tabItem {
                    Image(systemName: "building.columns")
                    Text("Companies")
                }
                .tag(3)
            
            BalanceView()
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal")
                    Text("Balance")
                }
                .tag(4)
            
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
