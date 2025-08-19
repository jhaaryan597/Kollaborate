import Foundation

class ProjectService {
    static let shared = ProjectService()
    
    func createProject(name: String, description: String) async throws {
        // Create project in backend
    }
    
    func fetchProjects() async throws -> [Project] {
        // Fetch projects from backend
        return []
    }
    
    func updateProject(_ project: Project) async throws {
        // Update project in backend
    }
    
    func deleteProject(_ project: Project) async throws {
        // Delete project in backend
    }
    
    func addTask(to project: Project, title: String) async throws {
        // Add task to project in backend
    }
    
    func updateTask(_ task: Task) async throws {
        // Update task in backend
    }
    
    func deleteTask(_ task: Task) async throws {
        // Delete task in backend
    }
}
