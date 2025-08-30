import SwiftUI

struct CommentView: View {
    @State private var commentText = ""
    @StateObject private var viewModel: CommentViewModel
    
    init(kollaborate: Kollaborate) {
        _viewModel = StateObject(wrappedValue: CommentViewModel(kollaborate: kollaborate))
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
