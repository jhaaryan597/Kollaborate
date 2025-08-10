import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var userSession: User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$currentUser.sink { [weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellables)
    }
}
