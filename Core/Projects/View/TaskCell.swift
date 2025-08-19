import SwiftUI

struct TaskCell: View {
    let task: Task
    
    var body: some View {
        HStack {
            Button(action: {
                // Toggle task completion
            }) {
                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(task.isCompleted ? Color("AccentColor") : Color("SecondaryText"))
            }
            
            Text(task.title)
                .font(.system(size: 14))
                .foregroundColor(Color("PrimaryText"))
            
            Spacer()
        }
        .padding()
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(task: Task(id: "1", title: "Sample Task", isCompleted: false))
    }
}
