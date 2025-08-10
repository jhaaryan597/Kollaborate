//
//  UserCell.swift
//  Kollaborate
//
//  Created by Aryan Jha on 9/3/23.
//

import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user, size: .small)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.username)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("PrimaryText"))
                
                Text(user.fullname)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("SecondaryText"))
            }
            .font(.footnote)
            
            Spacer()
            
            Text("Follow")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color("PrimaryText"))
                .frame(width: 100, height: 32)
                .background(Color("AccentColor"))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
    }
}
