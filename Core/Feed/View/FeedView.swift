import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var showCreateThreadView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Background
                Color("PrimaryBackground").ignoresSafeArea()
                
                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if viewModel.kollaborates.isEmpty {
                            // Header for empty feed
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Welcome Back!")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("PrimaryText"))
                                
                                Text("What's on your mind?")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("SecondaryText"))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            // Header for populated feed
                            Text("Feed")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("PrimaryText"))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Kollaborate Cells
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.kollaborates) { kollaborate in
                                    KollaborateCell(kollaborate: kollaborate)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    KollaborateCache.shared.fetchKollaborates()
                }
            }
            .navigationTitle("Feed")
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
