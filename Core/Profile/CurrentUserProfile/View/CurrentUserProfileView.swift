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
                    // Header
                    VStack {
                        // Profile Image
                        CircularProfileImageView(user: currentUser, size: .large)
                        
                        // User Info
                        VStack(spacing: 8) {
                            Text(currentUser?.fullname ?? "")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color("PrimaryText"))
                            
                            Text("@\(currentUser?.username ?? "")")
                                .font(.system(size: 14))
                                .foregroundColor(Color("SecondaryText"))
                        }
                        
                        // Edit Profile Button
                        Button {
                            showEditProfile.toggle()
                        } label: {
                            Text("Edit Profile")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color("PrimaryBackground"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("AccentColor"), Color("SecondaryAccent")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(8)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding()
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
