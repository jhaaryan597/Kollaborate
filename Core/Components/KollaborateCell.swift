import SwiftUI
import Supabase
import Combine

struct Comment: Identifiable, Codable {
    let id: UUID
    let postId: String
    let userId: UUID
    let commentText: String
    let createdAt: Date
    
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postId = "post_id"
        case userId = "user_id"
        case commentText = "comment_text"
        case createdAt = "created_at"
        case user
    }
}

class CommentService {
    static let shared = CommentService()
    private let client = supabase
    let newCommentSubject = PassthroughSubject<Void, Never>()
    
    private struct IncrementParams: Codable {
        let post_id: String
        let increment_amount: Int
    }
    
    func fetchComments(forPostId postId: String) async throws -> [Comment] {
        let comments: [Comment] = try await client
            .from("post_comments")
            .select("*, user:users(*)")
            .eq("post_id", value: postId)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return comments
    }
    
    func postComment(_ commentText: String, forPostId postId: String, userId: String) async throws {
        let comment = Comment(id: UUID(), postId: postId, userId: UUID(uuidString: userId)!, commentText: commentText, createdAt: Date())
        
        try await client
            .from("post_comments")
            .insert(comment)
            .execute()
        
        let params = IncrementParams(post_id: postId, increment_amount: 1)
        try await client.rpc("increment_comments", params: params).execute()
        newCommentSubject.send()
    }
    
    func deleteComment(withId commentId: UUID, postId: String) async throws {
        try await client
            .from("post_comments")
            .delete()
            .eq("id", value: commentId)
            .execute()
        
        let params = IncrementParams(post_id: postId, increment_amount: -1)
        try await client.rpc("increment_comments", params: params).execute()
    }
}

@MainActor
class KollaborateCellViewModel: ObservableObject {
    @Published var kollaborate: Kollaborate
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
        Task { try await checkIfUserLikedKollaborate() }
    }
    
    func like() async throws {
        try await KollaborateService.shared.likeKollaborate(kollaborate)
        self.kollaborate.likes += 1
        self.kollaborate.didLike = true
    }
    
    func unlike() async throws {
        try await KollaborateService.shared.unlikeKollaborate(kollaborate)
        self.kollaborate.likes -= 1
        self.kollaborate.didLike = false
    }
    
    func checkIfUserLikedKollaborate() async throws {
        self.kollaborate.didLike = try await KollaborateService.checkIfUserLikedKollaborate(kollaborate)
    }
}

struct KollaborateCell: View {
    @StateObject var viewModel: KollaborateCellViewModel
    
    init(kollaborate: Kollaborate) {
        self._viewModel = StateObject(wrappedValue: KollaborateCellViewModel(kollaborate: kollaborate))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User Info
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(user: viewModel.kollaborate.user, size: .small)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.kollaborate.user?.username ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("PrimaryText"))
                    
                    Text(viewModel.kollaborate.timestamp.timestampString())
                        .font(.system(size: 12))
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Spacer()
                
                Button {
                    // More options
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            
            // Caption
            Text(viewModel.kollaborate.caption)
                .font(.system(size: 14))
                .foregroundColor(Color("PrimaryText"))
                .multilineTextAlignment(.leading)
            
            // Action Buttons
            HStack(spacing: 24) {
                Button {
                    Task {
                        if viewModel.kollaborate.didLike == true {
                            try await viewModel.unlike()
                        } else {
                            try await viewModel.like()
                        }
                    }
                } label: {
                    Image(systemName: viewModel.kollaborate.didLike == true ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.kollaborate.didLike == true ? .red : Color("SecondaryText"))
                }
                
                NavigationLink(destination: CommentView(kollaborate: viewModel.kollaborate)) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(Color("SecondaryText"))
                        
                        Text("\(viewModel.kollaborate.commentsCount ?? 0)")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryText"))
                    }
                }
                
                Button {
                    // Repost
                } label: {
                    Image(systemName: "arrow.rectanglepath")
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    // Share
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct KollaborateCell_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateCell(kollaborate: dev.kollaborate)
    }
}

struct CommentView: View {
    @State private var commentText = ""
    @StateObject private var viewModel: CommentViewModel
    
    init(kollaborate: Kollaborate) {
        self._viewModel = StateObject(wrappedValue: CommentViewModel(kollaborate: kollaborate))
    }
    
    var body: some View {
        VStack {
            Text("Comments")
                .font(.title)
                .fontWeight(.bold)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comment.user?.username ?? "")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(comment.createdAt.dateString)
                                    .foregroundColor(.gray)
                            }
                            Text(comment.commentText)
                        }
                        .padding()
                        .background(Color("SurfaceHighlight"))
                        .cornerRadius(10)
                    }
                }
            }
            
            HStack {
                TextField("Add a comment...", text: $commentText)
                    .modifier(KollaborateTextFieldModifier())
                
                Button(action: {
                    Task {
                        await viewModel.postComment(commentText)
                        commentText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding()
        }
        .onAppear {
            Task { await viewModel.fetchComments() }
        }
    }
}

class CommentViewModel: ObservableObject {
    @Published var comments = [Comment]()
    private let kollaborate: Kollaborate
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
    }
    
    @MainActor
    func fetchComments() async {
        do {
            self.comments = try await CommentService.shared.fetchComments(forPostId: kollaborate.id)
        } catch {
            print("Failed to fetch comments: \(error)")
        }
    }
    
    @MainActor
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

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}
