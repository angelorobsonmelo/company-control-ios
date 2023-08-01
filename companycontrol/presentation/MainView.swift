import SwiftUI


struct MainView: View {
    @State private var selectedTab = 0
    @State private var showingDeleteConfirmation = false

    @EnvironmentObject var viewModel: AuthViewModel


    var body: some View {
                TabView(selection: $selectedTab) {
                    ExpensesView()
                        .tabItem {
                            Image(systemName: "creditcard.fill")
                            Text("EXPENSES".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 0
                        }
                        .tag(0)

                    ServicesView()
                        .tabItem {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("SERVICES".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 1
                        }
                        .tag(1)

                    CategoryView()
                        .tabItem {
                            Image(systemName: "square.stack")
                            Text("CATEGORIES".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 2
                        }
                        .tag(2)

                    CompanyView()
                        .tabItem {
                            Image(systemName: "building.columns")
                            Text("COMPANIES".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 3
                        }
                        .tag(3)

                    BalanceView()
                        .tabItem {
                            Image(systemName: "chart.bar.doc.horizontal")
                            Text("BALANCE".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 4
                        }
                        .tag(4)
                    
                    SchedulesView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("SCHEDULES".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 5
                        }
                        .tag(5)
                    
                    LogoutView()
                        .environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "power")
                            Text("LOG_OUT".localized)
                        }
                        .onAppear() {
                            self.selectedTab = 6
                        }
                        .tag(6)
                }
            }
    }


struct Content_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
