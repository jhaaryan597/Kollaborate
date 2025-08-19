import SwiftUI

struct KollaborateCell: View {
    let kollaborate: Kollaborate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User Info
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(user: kollaborate.user, size: .small)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(kollaborate.user?.username ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("PrimaryText"))
                    
                    Text(kollaborate.timestamp.timestampString())
                        .font(.system(size: 12))
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Spacer()
                
                Button {
                    // More options
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            
            // Caption
            Text(kollaborate.caption)
                .font(.system(size: 14))
                .foregroundColor(Color("PrimaryText"))
                .multilineTextAlignment(.leading)
            
            // Action Buttons
            HStack(spacing: 24) {
                Button {
                    // Like
                } label: {
                    Image(systemName: "heart")
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    // Comment
                } label: {
                    Image(systemName: "bubble.right")
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    // Repost
                } label: {
                    Image(systemName: "arrow.rectanglepath")
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    // Share
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            .padding(.top, 8)
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

struct KollaborateCell_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateCell(kollaborate: dev.kollaborate)
    }
}
