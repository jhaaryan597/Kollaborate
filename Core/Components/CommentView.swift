import SwiftUI

struct CommentView: View {
    @State private var commentText = ""
    @StateObject private var viewModel: CommentViewModel
    @State private var showingError = false
    
    init(kollaborate: Kollaborate) {
        _viewModel = StateObject(wrappedValue: CommentViewModel(kollaborate: kollaborate))
    }
    
    var body: some View {
        VStack {
            Text("Responses")
                .font(.title)
                .fontWeight(.bold)
            
            if viewModel.isLoading && viewModel.comments.isEmpty {
                ProgressView("Loading comments...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.comments) { comment in
                            CommentRowView(comment: comment, viewModel: viewModel)
                        }
                        
                        if viewModel.comments.isEmpty && !viewModel.isLoading {
                            Text("No responses yet")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                }
                .refreshable {
                    await viewModel.refreshComments()
                }
            }
            
            // Comment input section
            HStack {
                TextField("Add a comment...", text: $commentText)
                    .padding(12)
                    .background(Color("SurfaceHighlight"))
                    .cornerRadius(10)
                    .disabled(viewModel.isPostingComment)
                
                Button(action: {
                    Task {
                        await viewModel.postComment(commentText)
                        commentText = ""
                    }
                }) {
                    if viewModel.isPostingComment {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("AccentColor")))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isPostingComment)
            }
            .padding()
        }
        .onAppear {
            Task { 
                print("🔄 CommentView appeared, fetching comments...")
                await viewModel.fetchComments() 
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { 
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            showingError = errorMessage != nil
        }
    }
}

struct CommentRowView: View {
    let comment: Comment
    @ObservedObject var viewModel: CommentViewModel
    @State private var showReplyField = false
    @State private var showReplies = false
    @State private var replyText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(comment.user?.username ?? "Anonymous")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("PrimaryText"))
                Spacer()
                Text(comment.createdAt.dateString)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(comment.commentText)
                .foregroundColor(Color("SecondaryText"))
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 16) {
                Button(action: {
                    showReplyField.toggle()
                }) {
                    Text("Reply")
                        .font(.caption)
                        .foregroundColor(Color("AccentColor"))
                }
                
                if let replies = comment.replies, !replies.isEmpty {
                    Button(action: {
                        showReplies.toggle()
                    }) {
                        Text(showReplies ? "Hide Replies" : "View Replies (\(replies.count))")
                            .font(.caption)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            
            if showReplyField {
                HStack {
                    TextField("Add a reply...", text: $replyText)
                        .padding(8)
                        .background(Color("SurfaceHighlight"))
                        .cornerRadius(8)
                    
                    Button(action: {
                        Task {
                            await viewModel.postComment(replyText, parentCommentId: comment.id)
                            replyText = ""
                            showReplyField = false
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            
            if showReplies, let replies = comment.replies {
                ForEach(replies) { reply in
                    HStack {
                        Rectangle()
                            .fill(Color("AccentColor"))
                            .frame(width: 2)
                        
                        CommentRowView(comment: reply, viewModel: viewModel)
                    }
                    .padding(.leading, 20)
                }
            }
        }
        .padding(8)
        .background(Color("SurfaceHighlight"))
        .cornerRadius(10)
    }
}

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}
