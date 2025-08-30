import Foundation

@MainActor
class KollaborateCellViewModel: ObservableObject {
    @Published var kollaborate: Kollaborate
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
    }
    
    func like() async throws {
        // This function will be implemented later
    }
    
    func unlike() async throws {
        // This function will be implemented later
    }
}
