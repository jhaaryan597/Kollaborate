//
//  LoginViewModel.swift
//  Kollaborate
//
//  Created by Aryan Jha on 9/3/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @MainActor
    func login() async {
        let result = await AuthService.shared.login(
            withEmail: email,
            password: password
        )
        
        switch result {
        case .success:
            // Handle successful login
            break
        case .failure(let error):
            // Handle error
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
}
