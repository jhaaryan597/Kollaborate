import Foundation
import Supabase
import Combine

public class TaskService {
    
    public static let shared = TaskService()
    public let taskUpdateSubject = PassthroughSubject<Void, Never>()
    
    private struct EncodableTask: Encodable {
        let id: UUID
        let owner_uid: UUID
        let title: String
        let description: String?
        let due_date: String?
        let priority: String
        let is_completed: Bool
        let created_at: String
        let updated_at: String
    }
    
    public func createTask(_ task: TaskItem) async throws {
        guard let id = UUID(uuidString: task.id),
              let ownerUid = UUID(uuidString: task.ownerUid) else {
            throw NSError(domain: "TaskServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UUID string"])
        }
        
        let encodableTask = EncodableTask(
            id: id,
            owner_uid: ownerUid,
            title: task.title,
            description: task.description,
            due_date: task.dueDate?.ISO8601Format(),
            priority: task.priority.rawValue,
            is_completed: task.isCompleted,
            created_at: task.createdAt.ISO8601Format(),
            updated_at: task.updatedAt.ISO8601Format()
        )
        
        do {
            try await supabase.database
                .from("tasks")
                .insert(encodableTask, returning: .minimal)
                .execute()
            
            taskUpdateSubject.send()
        } catch {
            print("Error creating task: \(error)")
            throw error
        }
    }
    
    public func fetchUserTasks(uid: String) async throws -> [TaskItem] {
        let tasks: [TaskItem] = try await supabase.database
            .from("tasks")
            .select()
            .eq("owner_uid", value: uid)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return tasks
    }
    
    public func updateTask(_ task: TaskItem) async throws {
        guard let id = UUID(uuidString: task.id),
              let ownerUid = UUID(uuidString: task.ownerUid) else {
            throw NSError(domain: "TaskServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UUID string"])
        }
        
        let encodableTask = EncodableTask(
            id: id,
            owner_uid: ownerUid,
            title: task.title,
            description: task.description,
            due_date: task.dueDate?.ISO8601Format(),
            priority: task.priority.rawValue,
            is_completed: task.isCompleted,
            created_at: task.createdAt.ISO8601Format(),
            updated_at: Date().ISO8601Format()
        )
        
        try await supabase.database
            .from("tasks")
            .update(encodableTask)
            .eq("id", value: task.id)
            .execute()
        
        taskUpdateSubject.send()
    }
    
    public func deleteTask(taskId: String) async throws {
        try await supabase.database
            .from("tasks")
            .delete()
            .eq("id", value: taskId)
            .execute()
        
        taskUpdateSubject.send()
    }
    
    private struct TaskUpdate: Encodable {
        let is_completed: Bool
        let updated_at: String
    }
    
    public func toggleTaskCompletion(taskId: String, isCompleted: Bool) async throws {
        let updateData = TaskUpdate(
            is_completed: isCompleted,
            updated_at: Date().ISO8601Format()
        )
        
        try await supabase.database
            .from("tasks")
            .update(updateData)
            .eq("id", value: taskId)
            .execute()
        
        taskUpdateSubject.send()
    }
    
    public func fetchTasksByPriority(uid: String, priority: TaskPriority) async throws -> [TaskItem] {
        let tasks: [TaskItem] = try await supabase.database
            .from("tasks")
            .select()
            .eq("owner_uid", value: uid)
            .eq("priority", value: priority.rawValue)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return tasks
    }
    
    public func fetchCompletedTasks(uid: String) async throws -> [TaskItem] {
        let tasks: [TaskItem] = try await supabase.database
            .from("tasks")
            .select()
            .eq("owner_uid", value: uid)
            .eq("is_completed", value: true)
            .order("updated_at", ascending: false)
            .execute()
            .value
        
        return tasks
    }
    
    public func fetchPendingTasks(uid: String) async throws -> [TaskItem] {
        let tasks: [TaskItem] = try await supabase.database
            .from("tasks")
            .select()
            .eq("owner_uid", value: uid)
            .eq("is_completed", value: false)
            .order("due_date", ascending: true)
            .order("priority", ascending: false)
            .execute()
            .value
        
        return tasks
    }
}
