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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryBackground").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    Text("New Task")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                        .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Task Details Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Task Details")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                TextField("Task title", text: $title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(Color("PrimaryText"))
                                    .background(Color("SurfaceHighlight"))
                                    .cornerRadius(8)
                                
                                TextField("Description (optional)", text: $description, axis: .vertical)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(Color("PrimaryText"))
                                    .background(Color("SurfaceHighlight"))
                                    .cornerRadius(8)
                                    .lineLimit(3...6)
                            }
                            
                            // Priority Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Priority")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                Picker("Priority", selection: $priority) {
                                    ForEach(TaskPriority.allCases, id: \.self) { priority in
                                        HStack {
                                            Circle()
                                                .fill(priorityColor(priority))
                                                .frame(width: 12, height: 12)
                                            Text(priority.rawValue.capitalized)
                                                .foregroundColor(Color("PrimaryText"))
                                        }
                                        .tag(priority)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .background(Color("SurfaceHighlight"))
                                .cornerRadius(8)
                            }
                            
                            // Due Date Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Due Date")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                Toggle("Set due date", isOn: $hasDueDate)
                                    .foregroundColor(Color("PrimaryText"))
                                    .background(Color("SurfaceHighlight"))
                                    .cornerRadius(8)
                                
                                if hasDueDate {
                                    DatePicker(
                                        "Due Date",
                                        selection: $dueDate,
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                    .foregroundColor(Color("PrimaryText"))
                                    .background(Color("SurfaceHighlight"))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryText"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    .foregroundColor(Color("PrimaryText"))
                }
            }
        }
        .environment(\.colorScheme, .dark)
    }
    
    private func saveTask() {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        
        isLoading = true
        
        let task = TaskItem(
            id: UUID().uuidString,
            ownerUid: uid,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority
        )
        
        onSave(task)
        dismiss()
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
