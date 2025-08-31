import SwiftUI

struct TaskDetailView: View {
    let task: TaskItem
    let onUpdate: (TaskItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var priority: TaskPriority
    @State private var hasDueDate: Bool
    @State private var isEditing = false
    @State private var isLoading = false
    
    init(task: TaskItem, onUpdate: @escaping (TaskItem) -> Void) {
        self.task = task
        self.onUpdate = onUpdate
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description ?? "")
        self._dueDate = State(initialValue: task.dueDate ?? Date())
        self._priority = State(initialValue: task.priority)
        self._hasDueDate = State(initialValue: task.dueDate != nil)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryBackground").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    Text("Task Details")
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
                                
                                if isEditing {
                                    TextField("Task title", text: $title)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(Color("PrimaryText"))
                                        .background(Color("SurfaceHighlight"))
                                        .cornerRadius(8)
                                    
                                    TextField("Description", text: $description, axis: .vertical)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(Color("PrimaryText"))
                                        .background(Color("SurfaceHighlight"))
                                        .cornerRadius(8)
                                        .lineLimit(3...6)
                                } else {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("Title")
                                                .foregroundColor(Color("SecondaryText"))
                                            Spacer()
                                            Text(title)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("PrimaryText"))
                                        }
                                        .padding()
                                        .background(Color("SurfaceHighlight"))
                                        .cornerRadius(8)
                                        
                                        if !description.isEmpty {
                                            HStack {
                                                Text("Description")
                                                    .foregroundColor(Color("SecondaryText"))
                                                Spacer()
                                                Text(description)
                                                    .foregroundColor(Color("PrimaryText"))
                                                    .multilineTextAlignment(.trailing)
                                            }
                                            .padding()
                                            .background(Color("SurfaceHighlight"))
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            
                            // Status Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Status")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                HStack {
                                    Text("Completed")
                                        .foregroundColor(Color("SecondaryText"))
                                    Spacer()
                                    Button(action: {
                                        let updatedTask = TaskItem(
                                            id: task.id,
                                            ownerUid: task.ownerUid,
                                            title: task.title,
                                            description: task.description,
                                            dueDate: task.dueDate,
                                            priority: task.priority,
                                            isCompleted: !task.isCompleted,
                                            createdAt: task.createdAt,
                                            updatedAt: Date(),
                                            user: task.user
                                        )
                                        onUpdate(updatedTask)
                                    }) {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                            .foregroundColor(task.isCompleted ? .green : Color("SecondaryText"))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding()
                                .background(Color("SurfaceHighlight"))
                                .cornerRadius(8)
                            }
                            
                            // Priority Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Priority")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                if isEditing {
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
                                } else {
                                    HStack {
                                        Text("Priority")
                                            .foregroundColor(Color("SecondaryText"))
                                        Spacer()
                                        Text(priority.rawValue.capitalized)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(priorityColor(priority).opacity(0.2))
                                            .foregroundColor(priorityColor(priority))
                                            .clipShape(Capsule())
                                    }
                                    .padding()
                                    .background(Color("SurfaceHighlight"))
                                    .cornerRadius(8)
                                }
                            }
                            
                            // Due Date Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Due Date")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                if isEditing {
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
                                } else {
                                    if let dueDate = task.dueDate {
                                        HStack {
                                            Text("Due Date")
                                                .foregroundColor(Color("SecondaryText"))
                                            Spacer()
                                            Text(dueDate, style: .date)
                                                .foregroundColor(isOverdue(dueDate) ? .red : Color("PrimaryText"))
                                        }
                                        .padding()
                                        .background(Color("SurfaceHighlight"))
                                        .cornerRadius(8)
                                    } else {
                                        HStack {
                                            Text("Due Date")
                                                .foregroundColor(Color("SecondaryText"))
                                            Spacer()
                                            Text("No due date")
                                                .foregroundColor(Color("SecondaryText"))
                                        }
                                        .padding()
                                        .background(Color("SurfaceHighlight"))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            
                            // Timestamps Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Timestamps")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Created")
                                            .foregroundColor(Color("SecondaryText"))
                                        Spacer()
                                        Text(task.createdAt, style: .date)
                                            .foregroundColor(Color("PrimaryText"))
                                    }
                                    
                                    HStack {
                                        Text("Last Updated")
                                            .foregroundColor(Color("SecondaryText"))
                                        Spacer()
                                        Text(task.updatedAt, style: .date)
                                            .foregroundColor(Color("PrimaryText"))
                                    }
                                }
                                .padding()
                                .background(Color("SurfaceHighlight"))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryText"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                        }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                        .foregroundColor(Color("PrimaryText"))
                    } else {
                        Button("Edit") {
                            isEditing = true
                        }
                        .foregroundColor(Color("PrimaryText"))
                    }
                }
            }
        }
        .environment(\.colorScheme, .dark)
    }
    
    private func saveChanges() {
        isLoading = true
        
        let updatedTask = TaskItem(
            id: task.id,
            ownerUid: task.ownerUid,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority,
            isCompleted: task.isCompleted,
            createdAt: task.createdAt,
            updatedAt: Date(),
            user: task.user
        )
        
        onUpdate(updatedTask)
        isEditing = false
        isLoading = false
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
    
    private func isOverdue(_ date: Date) -> Bool {
        return date < Date() && !task.isCompleted
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(
            task: TaskItem(
                id: "1",
                ownerUid: "user1",
                title: "Sample Task",
                description: "This is a sample task description",
                dueDate: Date().addingTimeInterval(86400),
                priority: .high
            ),
            onUpdate: { _ in }
        )
    }
}
