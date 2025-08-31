//
//  ProfileHeaderView.swift
//  Threads Clone
//
//  Created by Aryan Jha on 9/5/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                // fullname and username
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullname ?? "")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                    
                    Text(user?.username ?? "")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("SecondaryText"))
                }
                
                if let bio = user?.bio {
                    Text(bio)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("PrimaryText"))
                }
                
                Text("2 connections")
                    .font(.caption)
                    .foregroundColor(Color("SecondaryText"))
            }
            
            Spacer()
            
            CircularProfileImageView(user: user, size: .medium)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: dev.user)
    }
}
