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
                Text("Follow")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color("AccentColor"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
    }
}
