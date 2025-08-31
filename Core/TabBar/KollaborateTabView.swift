import SwiftUI

struct KollaborateTabView: View {
    @State private var selectedTab = 0
    @State private var showCreateThreadView = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTab = 1 }
                .tag(1)

            Text("")
                .tabItem {
                    Image(systemName: "plus")
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            TaskManagementView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "checklist.fill" : "checklist")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 2 {
                showCreateThreadView.toggle()
            }
        }
        .sheet(isPresented: $showCreateThreadView, onDismiss: {
            selectedTab = 0
        }) {
            CreateThreadView()
        }
        .tint(Color("AccentColor"))
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "SecondaryText")
        }
    }
}

struct KollaborateTabView_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateTabView()
    }
}
