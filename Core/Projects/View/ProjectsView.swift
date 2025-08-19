import SwiftUI

struct ProjectsView: View {
    @StateObject var viewModel = ProjectsViewModel()
    @State private var showCreateProject = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Background
                Color("PrimaryBackground").ignoresSafeArea()
                
                // Main Content
                ScrollView {
                    VStack {
                        // Header
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Projects")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("PrimaryText"))
                            
                            Text("Collaborate with others on your projects.")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("SecondaryText"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Project List
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.projects) { project in
                                ProjectCell(project: project)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Floating Action Button
                Button(action: {
                    showCreateProject.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
                .sheet(isPresented: $showCreateProject) {
                    CreateProjectView()
                }
            }
            .navigationTitle("Projects")
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
