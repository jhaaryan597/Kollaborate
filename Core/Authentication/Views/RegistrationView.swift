import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Kollaborate-app-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(KollaborateTextFieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(KollaborateTextFieldModifier())
                
                TextField("Enter your full name", text: $viewModel.fullname)
                    .modifier(KollaborateTextFieldModifier())
                
                TextField("Enter your username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .modifier(KollaborateTextFieldModifier())
                
                TextField("Enter your organization ID", text: $viewModel.organizationId)
                    .autocapitalization(.none)
                    .modifier(KollaborateTextFieldModifier())
            }
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign Up")
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
            .padding(.vertical)
            
            Spacer()
            
            Divider()
                .background(Color("SurfaceHighlight"))
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign In")
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
