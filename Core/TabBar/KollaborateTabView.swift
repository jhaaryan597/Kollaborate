import SwiftUI

struct KollaborateTabView: View {
    @State private var selectedTab = 0
    
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

            ChannelsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            Text("")
                .tabItem {
                    Image(systemName: "plus")
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            
            ActivityView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
            
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 5 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 5 ? .fill : .none)
                }
                .onAppear { selectedTab = 5 }
                .tag(5)
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
