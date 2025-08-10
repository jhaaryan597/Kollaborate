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
                // bio and stats
                VStack(spacing: 20) {
                        ProfileHeaderView(user: currentUser)
                    
                    Button {
                        showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PrimaryText"))
                            .frame(width: 352, height: 32)
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(8)
                    }
                    
                    // user content list view
                    if let user = currentUser {
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
            .padding(.horizontal)
            .background(Color("PrimaryBackground"))
        }
        .environment(\.colorScheme, .dark)
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
    }
}
