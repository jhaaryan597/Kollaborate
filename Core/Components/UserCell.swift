import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            CircularProfileImageView(user: user, size: .medium)
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("PrimaryText"))
                
                Text(user.fullname)
                    .font(.system(size: 14))
                    .foregroundColor(Color("SecondaryText"))
            }
            
            Spacer()
            
            // Follow Button
            Button(action: {
                // Follow user
            }) {
                Text("Connect")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("PrimaryText"))
                    .frame(width: 100, height: 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("PrimaryText"), lineWidth: 1)
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
    }
}
