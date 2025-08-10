import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.kollaborates) { kollaborate in
                        KollaborateCell(kollaborate: kollaborate)
                    }
                }
            }
            .refreshable {
                Task { try await viewModel.fetchKollaborates() }
            }
            .navigationTitle("Kollaborate")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("PrimaryBackground"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { try await viewModel.fetchKollaborates() }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color("PrimaryText"))
                    }
                }
            }
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
            }
        }
        .background(Color("PrimaryBackground"))
        .environment(\.colorScheme, .dark)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeedView()
        }
    }
}
