import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user = User(id: NSUUID().uuidString, fullname: "Tommy Shelby", email: "tommy@gmail.com", username: "tommy_shelby1")
    
    let kollaborate = Kollaborate(id: NSUUID().uuidString, ownerUid: "123", caption: "This is a test thread", timestamp: Date(), likes: 0)
}
