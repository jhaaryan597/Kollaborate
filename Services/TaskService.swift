import Foundation
import Supabase
import Combine

public struct TaskService {
    
    public static let shared = TaskService()
    public let taskUpdateSubject = PassthroughSubject<Void, Never>()
    
    private struct EncodableTask: Encodable {
        let id: String
        let owner_uid: String
        let title: String
        let description: String?
        let due_date: String?
        let priority: String
        let is_completed: Bool
        let created_at: String
        let updated_at: String
    }
    
    public static func createTask(_ task: TaskItem) async throws {
        let encodableTask = EncodableTask(
            id: task.id,
            owner_uid: task.ownerUid,
            title: task.title,
            description: task.description,
            due_date: task.dueDate?.ISO8601Format(),
            priority: task.priority.rawValue,
            is_completed: task.isCompleted,
            created_at: task.createdAt.ISO8601Format(),
            updated_at: task.updatedAt.ISO8601Format()
        )
        
        try await supabase.database
            .from("tasks")
            .insert(encodableTask)
            .execute()
    }
    
    public static func fetchUserTasks(uid: String) async throws -> [TaskItem] {
        let tasks: [TaskItem] = try await supabase.database
            .from("tasks")
            .select()
            .eq("owner_uid", value: uid)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return tasks
    }
    
    public static func updateTask(_ task: TaskItem) async throws {
        let encodableTask = EncodableTask(
            id: task.id,
            owner_uid: task.ownerUid,
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
    }
    
    public static func deleteTask(taskId: String) async throws {
        try await supabase.database
            .from("tasks")
            .delete()
            .eq("id", value: taskId)
            .execute()
    }
    
    private struct TaskUpdate: Encodable {
        let is_completed: Bool
        let updated_at: String
    }
    
    public static func toggleTaskCompletion(taskId: String, isCompleted: Bool) async throws {
        let updateData = TaskUpdate(
            is_completed: isCompleted,
            updated_at: Date().ISO8601Format()
        )
        
        try await supabase.database
            .from("tasks")
            .update(updateData)
            .eq("id", value: taskId)
            .execute()
    }
    
    public static func fetchTasksByPriority(uid: String, priority: TaskPriority) async throws -> [TaskItem] {
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
    
    public static func fetchCompletedTasks(uid: String) async throws -> [TaskItem] {
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
    
    public static func fetchPendingTasks(uid: String) async throws -> [TaskItem] {
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
