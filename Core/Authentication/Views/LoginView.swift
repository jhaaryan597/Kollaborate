import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color("PrimaryBackground"), Color("SecondaryBackground")]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                VStack(spacing: 20) {
                    // App Icon and Title
                    VStack {
                        Image("Kollaborate-app-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 240)
                            .padding(.bottom, -60)
                        
                        Text("Welcome back")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color("PrimaryText"))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 20)
                    
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
                    }
                    .padding(.horizontal, 30)
                    
                    // Forgot Password
                    NavigationLink {
                        Text("Forgot password")
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("AccentColor"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 30)
                    }
                    
                    // Login Button
                    Button {
                        Task { await viewModel.login() }
                    } label: {
                        Text("Login")
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
                    .padding(.horizontal, 120)
                    
                    Spacer()
                    
                    // Sign Up Link
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 3) {
                            Text("Don't have an account?")
                                .font(.system(size: 12))
                                .foregroundColor(Color("SecondaryText"))
                            
                            Text("Sign Up")
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
