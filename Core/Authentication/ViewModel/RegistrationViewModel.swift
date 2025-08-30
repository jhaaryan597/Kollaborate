import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    
    @MainActor
    func createUser() async {
        let result = await AuthService.shared.createUser(
            withEmail: email,
            password: password,
            fullname: fullname,
            username: username,
            role: .employee
        )
        
        switch result {
        case .success:
            // Handle successful registration
            break
        case .failure(let error):
            // Handle error
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
}
