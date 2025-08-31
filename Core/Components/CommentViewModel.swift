import Foundation
import SwiftUI

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var kollaborate: Kollaborate
    @Published var isLoading = false
    @Published var isPostingComment = false
    @Published var errorMessage: String?
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
    }
    
    func fetchComments() async {
        isLoading = true
        errorMessage = nil
        
        do {
            print("🔄 Fetching comments for post: \(kollaborate.id)")
            let fetchedComments = try await CommentService.shared.fetchComments(forPostId: kollaborate.id)
            print("✅ Fetched \(fetchedComments.count) comments")
            
            // Force UI update on main thread
            await MainActor.run {
                self.comments = fetchedComments
                self.isLoading = false
                print("📱 UI updated with \(self.comments.count) comments")
            }
        } catch {
            print("❌ Failed to fetch comments: \(error)")
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func postComment(_ commentText: String) async {
        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("⚠️ Empty comment text")
            return
        }
        
        guard let userId = AuthService.shared.currentUser?.id else {
            print("❌ User not authenticated")
            errorMessage = "User not authenticated"
            return
        }
        
        isPostingComment = true
        errorMessage = nil
        
        do {
            print("🔄 Posting comment: \(commentText)")
            try await CommentService.shared.postComment(commentText, forPostId: kollaborate.id, userId: userId)
            print("✅ Comment posted successfully")
            
            // Update comment count
            await MainActor.run {
                self.kollaborate.commentsCount = (self.kollaborate.commentsCount ?? 0) + 1
            }
            
            // Fetch updated comments
            await fetchComments()
            
            await MainActor.run {
                self.isPostingComment = false
            }
        } catch {
            print("❌ Failed to post comment: \(error)")
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isPostingComment = false
            }
        }
    }
    
    func refreshComments() async {
        await fetchComments()
    }
}