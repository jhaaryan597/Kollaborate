import Foundation

public enum TaskPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
}

public struct TaskItem: Identifiable, Codable, Hashable {
    public let id: String
    public let ownerUid: String
    public let title: String
    public let description: String?
    public let dueDate: Date?
    public let priority: TaskPriority
    public let isCompleted: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public var user: User?
    
    public init(id: String, ownerUid: String, title: String, description: String? = nil, dueDate: Date? = nil, priority: TaskPriority = .medium, isCompleted: Bool = false, createdAt: Date = Date(), updatedAt: Date = Date(), user: User? = nil) {
        self.id = id
        self.ownerUid = ownerUid
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerUid = "owner_uid"
        case title
        case description
        case dueDate = "due_date"
        case priority
        case isCompleted = "is_completed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}
