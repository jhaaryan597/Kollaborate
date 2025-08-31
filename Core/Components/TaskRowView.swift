import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let onUpdate: (TaskItem) -> Void
    let onDelete: () -> Void
    
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Completion Checkbox
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
                
                // Task Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(task.title)
                            .font(.system(size: 14, weight: .semibold))
                            .strikethrough(task.isCompleted)
                            .foregroundColor(task.isCompleted ? Color("SecondaryText") : Color("PrimaryText"))
                        
                        Spacer()
                        
                        // Priority Indicator
                        priorityBadge
                    }
                    
                    if let description = task.description, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 12))
                            .foregroundColor(Color("SecondaryText"))
                            .lineLimit(2)
                    }
                    
                    if let dueDate = task.dueDate {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text(dueDate, style: .date)
                                .font(.caption)
                                .foregroundColor(isOverdue(dueDate) ? .red : Color("SecondaryText"))
                        }
                    }
                }
                
                Spacer()
                
                // Details Button
                Button(action: { showingDetails = true }) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundColor(Color("SecondaryText"))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showingDetails) {
            TaskDetailView(task: task) { updatedTask in
                onUpdate(updatedTask)
                showingDetails = false
            }
        }
    }
    
    private var priorityBadge: some View {
        Text(task.priority.rawValue.capitalized)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(priorityColor.opacity(0.2))
            .foregroundColor(priorityColor)
            .clipShape(Capsule())
    }
    
    private var priorityColor: Color {
        switch task.priority {
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

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(
            task: TaskItem(
                id: "1",
                ownerUid: "user1",
                title: "Sample Task",
                description: "This is a sample task description",
                dueDate: Date().addingTimeInterval(86400),
                priority: .high
            ),
            onUpdate: { _ in },
            onDelete: {}
        )
        .padding()
    }
}
