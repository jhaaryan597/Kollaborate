import SwiftUI

struct KollaborateCell: View {
    let kollaborate: Kollaborate
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(user: kollaborate.user, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(kollaborate.user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(kollaborate.timestamp.timestampString())
                            .font(.caption)
                            .foregroundColor(Color(.systemGray3))
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                    
                    Text(kollaborate.caption)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 16) {
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "bubble.right")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.rectanglepath")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                }
            }
            
            Divider()
        }
        .padding()
    }
}

struct KollaborateCell_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateCell(kollaborate: dev.kollaborate)
    }
}
