import SwiftUI

struct TaskManagementView: View {
    @StateObject private var viewModel = TaskManagementViewModel()
    @State private var showAddTask = false
    @State private var selectedFilter: TaskFilter = .all
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color("PrimaryBackground").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with Add Button
                    HStack {
                        Spacer()
                        Text("Task Management")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("PrimaryText"))
                        Spacer()
                        
                        Button(action: { showAddTask = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(Color("PrimaryText"))
                        }
                    }
                    .padding()
                    
                    // Filter Picker
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(TaskFilter.allCases, id: \.self) { filter in
                            Text(filter.displayName).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Task List
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .foregroundColor(Color("PrimaryText"))
                        Spacer()
                    } else if viewModel.filteredTasks.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "checklist")
                                .font(.system(size: 60))
                                .foregroundColor(Color("SecondaryText"))
                            Text("No tasks yet")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(Color("PrimaryText"))
                            Text("Tap the + button to add your first task")
                                .font(.body)
                                .foregroundColor(Color("SecondaryText"))
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredTasks) { task in
                                    TaskRowView(task: task) { updatedTask in
                                        Task {
                                            await viewModel.updateTask(updatedTask)
                                        }
                                    } onDelete: {
                                        Task {
                                            await viewModel.deleteTask(task)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddTask) {
                AddTaskView { task in
                    Task {
                        await viewModel.addTask(task)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadTasks()
                }
            }
            .onChange(of: selectedFilter) { _ in
                viewModel.applyFilter(selectedFilter)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

enum TaskFilter: String, CaseIterable {
    case all = "all"
    case pending = "pending"
    case completed = "completed"
    case highPriority = "high_priority"
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .pending: return "Pending"
        case .completed: return "Completed"
        case .highPriority: return "High Priority"
        }
    }
}

struct TaskManagementView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagementView()
    }
}
