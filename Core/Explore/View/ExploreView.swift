import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @StateObject var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color("PrimaryBackground").ignoresSafeArea()
                
                // Main Content
                ScrollView {
                    VStack {
                        // Header
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Discover")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("PrimaryText"))
                            
                            Text("Find new people and projects to collaborate with.")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("SecondaryText"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("SecondaryText"))
                            TextField("Search for users or projects", text: $searchText)
                                .font(.system(size: 14))
                                .foregroundColor(Color("PrimaryText"))
                        }
                        .padding()
                        .background(Color("SurfaceHighlight"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // User List
                        LazyVStack {
                            ForEach(viewModel.users) { user in
                                NavigationLink(value: user) {
                                    UserCell(user: user)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationTitle("Explore")
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
