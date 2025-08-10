import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @StateObject var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            VStack {
                                UserCell(user: user)
                                
                                Divider()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search")
            .background(Color("PrimaryBackground"))
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(named: "SurfaceHighlight")
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor(named: "PrimaryText")
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor(named: "PrimaryText")
            }
        }
        .background(Color("PrimaryBackground"))
        .environment(\.colorScheme, .dark)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
