import Foundation
import Combine

@MainActor
class TaskManagementViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var filteredTasks: [TaskItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        TaskService.shared.taskUpdateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task {
                    await self?.loadTasks()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadTasks() async {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            tasks = try await TaskService.fetchUserTasks(uid: uid)
            applyFilter(.all)
        } catch {
            errorMessage = "Failed to load tasks: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addTask(_ task: TaskItem) async {
        do {
            try await TaskService.createTask(task)
            await loadTasks()
        } catch {
            errorMessage = "Failed to create task: \(error.localizedDescription)"
        }
    }
    
    func updateTask(_ task: TaskItem) async {
        do {
            try await TaskService.updateTask(task)
            await loadTasks()
        } catch {
            errorMessage = "Failed to update task: \(error.localizedDescription)"
        }
    }
    
    func deleteTask(_ task: TaskItem) async {
        do {
            try await TaskService.deleteTask(taskId: task.id)
            await loadTasks()
        } catch {
            errorMessage = "Failed to delete task: \(error.localizedDescription)"
        }
    }
    
    func toggleTaskCompletion(_ task: TaskItem) async {
        do {
            try await TaskService.toggleTaskCompletion(taskId: task.id, isCompleted: !task.isCompleted)
            await loadTasks()
        } catch {
            errorMessage = "Failed to update task: \(error.localizedDescription)"
        }
    }
    
    func applyFilter(_ filter: TaskFilter) {
        switch filter {
        case .all:
            filteredTasks = tasks
        case .pending:
            filteredTasks = tasks.filter { !$0.isCompleted }
        case .completed:
            filteredTasks = tasks.filter { $0.isCompleted }
        case .highPriority:
            filteredTasks = tasks.filter { $0.priority == .high || $0.priority == .urgent }
        }
    }
    
    func getTaskStats() -> (total: Int, completed: Int, pending: Int) {
        let total = tasks.count
        let completed = tasks.filter { $0.isCompleted }.count
        let pending = total - completed
        return (total, completed, pending)
    }
}
