import SwiftUI

struct AddTaskView: View {
    let onSave: (TaskItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority: TaskPriority = .medium
    @State private var hasDueDate = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("New Task")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.top)
                
                VStack(spacing: 24) {
                    // Task Details Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Task Details")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        TextField("Task title", text: $title)
                            .padding(12)
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(12)
                        
                        TextField("Description (optional)", text: $description, axis: .vertical)
                            .padding(12)
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(12)
                            .lineLimit(3...6)
                    }
                    
                    // Priority Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Priority")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        Menu {
                            Picker("Priority", selection: $priority) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    HStack {
                                        Circle()
                                            .fill(priorityColor(priority))
                                            .frame(width: 12, height: 12)
                                        Text(priority.rawValue.capitalized)
                                    }
                                    .tag(priority)
                                }
                            }
                        } label: {
                            HStack {
                                Text(priority.rawValue.capitalized)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.subheadline)
                            }
                            .padding(12)
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Due Date Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Due Date")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        Toggle("Set due date", isOn: $hasDueDate)
                            .padding(12)
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(12)
                        
                        if hasDueDate {
                            DatePicker(
                                "Due Date",
                                selection: $dueDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .padding(12)
                            .background(Color("SurfaceHighlight"))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                
                // Add Task Button
                Button(action: saveTask) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(isLoading ? "Adding..." : "Add Task")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(12)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                .padding(.horizontal)
            }
        }
        .background(Color("PrimaryBackground").ignoresSafeArea())
        .environment(\.colorScheme, .dark)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
    }
    
    private func saveTask() {
        print("saveTask() called")
        guard let uid = AuthService.shared.currentUser?.id else {
            print("Error: User not authenticated")
            errorMessage = "User not authenticated"
            showingError = true
            return
        }
        print("Authenticated user ID: \(uid)")
        
        isLoading = true
        
        let task = TaskItem(
            id: UUID().uuidString,
            ownerUid: uid,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority
        )
        
        print("Creating task: \(task)")
        
        // Create the task in the database first
        Task {
            do {
                try await TaskService.shared.createTask(task)
                print("✅ Task created successfully in database")
                
                // Call onSave callback and dismiss on main thread
                await MainActor.run {
                    onSave(task)
                    dismiss()
                }
            } catch {
                print("❌ Error creating task: \(error)")
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Failed to create task: \(error.localizedDescription)"
                    showingError = true
                }
            }
        }
    }
    
    private func priorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .blue
        case .high:
            return .orange
        case .urgent:
            return .red
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView { _ in }
    }
}