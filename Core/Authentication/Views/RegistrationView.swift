import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color("PrimaryBackground"), Color("SecondaryBackground")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // App Icon and Title
                VStack {
                    Image("Kollaborate-app-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("Create an Account")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                }
                .padding(.bottom, 40)
                
                // Input Fields
                VStack(spacing: 15) {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(Color("PrimaryText"))
                        .modifier(KollaborateTextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(Color("PrimaryText"))
                        .modifier(KollaborateTextFieldModifier())
                    
                    TextField("Enter your full name", text: $viewModel.fullname)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(Color("PrimaryText"))
                        .modifier(KollaborateTextFieldModifier())
                    
                    TextField("Enter your username", text: $viewModel.username)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(Color("PrimaryText"))
                        .modifier(KollaborateTextFieldModifier())
                }
                .padding(.horizontal, 30)
                
                // Sign Up Button
                Button {
                    Task { await viewModel.createUser() }
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("AccentColor"), Color("SecondaryAccent")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Sign In Link
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .font(.system(size: 12))
                            .foregroundColor(Color("SecondaryText"))
                        
                        Text("Sign In")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
