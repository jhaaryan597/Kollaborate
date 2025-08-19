import Foundation

class ProjectsViewModel: ObservableObject {
    @Published var projects = [Project]()
    
    init() {
        Task { try await fetchProjects() }
    }
    
    @MainActor
    func fetchProjects() async throws {
        self.projects = try await ProjectService.shared.fetchProjects()
    }
}
