import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        ZStack {
            // Background
            Color("PrimaryBackground").ignoresSafeArea()
            
            // Main Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(project.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        Text(project.description)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("SecondaryText"))
                    }
                    
                    // Files
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Files")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        // File List
                        // ForEach(project.files) { file in
                        //     FileCell(file: file)
                        // }
                        
                        Button(action: {
                            // Upload file
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Upload File")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                        }
                    }
                    
                    // Tasks
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tasks")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        // Task List
                        ForEach(project.tasks) { task in
                            TaskCell(task: task)
                        }
                        
                        Button(action: {
                            // Add task
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Task")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project(id: "1", name: "Sample Project", description: "This is a sample project description.", ownerId: "1", memberIds: [], tasks: []))
    }
}
