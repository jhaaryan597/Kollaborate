import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("Kollaborate-app-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .padding()
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(KollaborateTextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(KollaborateTextFieldModifier())
                }
                
                NavigationLink {
                    Text("Forgot password")
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .padding(.trailing, 28)
                        .foregroundColor(Color("PrimaryText"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                        .frame(width: 352, height: 44)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("AccentColor"), Color("AccentColor").opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
                
                Divider()
                    .background(Color("SurfaceHighlight"))
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color("PrimaryText"))
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("PrimaryBackground"))
            .environment(\.colorScheme, .dark)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
