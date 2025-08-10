import SwiftUI
import PhotosUI

struct EditProfileView: View {
    let user: User
    
    @State private var bio = ""
    @State private var link = ""
    @State private var isPrivateProfile = false
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = EditProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryBackground")
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                VStack {
                    // name and profile image
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("PrimaryText"))
                            
                            Text(user.fullname)
                                .foregroundColor(Color("SecondaryText"))
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(user: user, size: .small)
                            }
                        }
                    }
                    
                    Divider().background(Color("SurfaceHighlight"))
                    
                    // bio field
                    
                    VStack(alignment: .leading) {
                        Text("Bio")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PrimaryText"))
                        
                        TextField("Enter your bio...", text: $bio, axis: .vertical)
                            .foregroundColor(Color("SecondaryText"))
                    }
                    
                    Divider().background(Color("SurfaceHighlight"))
                    
                    VStack(alignment: .leading) {
                        Text("Link")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PrimaryText"))
                        
                        TextField("Add link...", text: $link)
                            .foregroundColor(Color("SecondaryText"))
                    }
                    
                    Divider().background(Color("SurfaceHighlight"))
                    
                    Toggle("Private Profile", isOn: $isPrivateProfile)
                        .foregroundColor(Color("PrimaryText"))
                }
                .font(.footnote)
                .padding()
                .background(Color("PrimaryBackground"))
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            try await viewModel.updateUserData()
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("AccentColor"))
                }
            }
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: dev.user)
    }
}
