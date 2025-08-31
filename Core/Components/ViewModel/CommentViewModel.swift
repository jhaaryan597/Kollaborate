import Foundation
import SwiftUI

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments = [Comment]()
    private let kollaborate: Kollaborate
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
    }
    
    func fetchComments() async {
        do {
            self.comments = try await CommentService.shared.fetchComments(forPostId: kollaborate.id)
        } catch {
            print("Failed to fetch comments: \(error)")
        }
    }
    
    func postComment(_ commentText: String) async {
        guard let userId = AuthService.shared.currentUser?.id else { return }
        do {
            try await CommentService.shared.postComment(commentText, forPostId: kollaborate.id, userId: userId)
            await fetchComments()
        } catch {
            print("Failed to post comment: \(error)")
        }
    }
}
