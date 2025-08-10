import Foundation
import SwiftUI
import Supabase

@MainActor
class CreateThreadViewModel: ObservableObject {
    @Published var selectedURL: URL?
    
    func uploadThread(caption: String, type: ThreadType) async throws {
        guard let uid = try? await supabase.auth.session.user.id else { return }
        
        var attachmentURL: String?
        if let selectedURL = selectedURL {
            attachmentURL = try await DocumentUploader.shared.uploadDocument(from: selectedURL)
        }
        
        let kollaborate = Kollaborate(id: NSUUID().uuidString, ownerUid: uid.uuidString, caption: caption, timestamp: Date(), likes: 0, attachmentURL: attachmentURL, type: type)
        try await KollaborateService.uploadKollaborate(kollaborate)
    }
}
