import SwiftUI


struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ExpensesView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("EXPENSES".localized)
                }
                .tag(0)
            
            ServicesView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("SERVICES".localized)
                }
                .tag(1)
            
            CategoryView()
                .tabItem {
                    Image(systemName: "square.stack")
                    Text("CATEGORIES".localized)
                }
                .tag(2)
            
            CompanyView()
                .tabItem {
                    Image(systemName: "building.columns")
                    Text("COMPANIES".localized)
                }
                .tag(3)
            
            BalanceView()
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal")
                    Text("BALANCE".localized)
                }
                .tag(4)
            
        }
    }
}



struct Content_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
