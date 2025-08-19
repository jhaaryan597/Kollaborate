import SwiftUI

struct CreateProjectView: View {
    @State private var name = ""
    @State private var description = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color("PrimaryBackground").ignoresSafeArea()
                
                // Main Content
                VStack(spacing: 20) {
                    // Header
                    Text("Create Project")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                    
                    // Input Fields
                    VStack(spacing: 15) {
                        TextField("Project Name", text: $name)
                            .font(.system(size: 14))
                            .padding()
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(10)
                            .foregroundColor(Color("PrimaryText"))
                        
                        TextField("Project Description", text: $description)
                            .font(.system(size: 14))
                            .padding()
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(10)
                            .foregroundColor(Color("PrimaryText"))
                    }
                    .padding(.horizontal, 30)
                    
                    // Create Button
                    Button {
                        Task {
                            try await ProjectService.shared.createProject(name: name, description: description)
                            dismiss()
                        }
                    } label: {
                        Text("Create")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationTitle("Create Project")
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView()
    }
}
