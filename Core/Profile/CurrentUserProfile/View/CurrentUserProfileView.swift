import SwiftUI

struct CurrentUserProfileView: View {
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State private var showEditProfile = false
    
    private var currentUser: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if let user = currentUser {
                        ProfileHeaderView(user: user)
                        UserContentListView(user: user)
                    }
                }
            }
            .sheet(isPresented: $showEditProfile, content: {
                if let user = currentUser {
                    EditProfileView(user: user)
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await AuthService.shared.signOut() }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(Color("PrimaryText"))
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
    }
}
