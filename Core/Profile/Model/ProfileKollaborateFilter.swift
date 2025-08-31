import Foundation

enum ProfileKollaborateFilter: Int, CaseIterable, Identifiable {
    case kollaborates
    case replies
    
    var title: String {
        switch self {
        case .kollaborates: return "Kollaborates"
        case .replies: return "Responses"
        }
    }
    
    var id: Int { return self.rawValue }
}
