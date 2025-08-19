import SwiftUI

struct ActivityView: View {
    @State private var selectedFilter: ActivityFilter = .all
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color("PrimaryBackground").ignoresSafeArea()
                
                // Main Content
                VStack {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Activity")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("PrimaryText"))
                        
                        Text("Stay up to date with your notifications.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("SecondaryText"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Filter Buttons
                    HStack {
                        ForEach(ActivityFilter.allCases, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                            }) {
                                Text(filter.title)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(selectedFilter == filter ? .white : Color("PrimaryText"))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedFilter == filter ? Color("AccentColor") : Color("SurfaceHighlight"))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Activity List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Sample Data
                            ForEach(0..<10) { _ in
                                ActivityCell()
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Activity")
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

enum ActivityFilter: Int, CaseIterable {
    case all
    case replies
    case mentions
    case likes
    
    var title: String {
        switch self {
        case .all: return "All"
        case .replies: return "Replies"
        case .mentions: return "Mentions"
        case .likes: return "Likes"
        }
    }
}

struct ActivityCell: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
                .foregroundColor(Color("AccentColor"))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("username")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("PrimaryText"))
                    
                    Text("liked your post.")
                        .font(.system(size: 14))
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Text("This is the content of the post that was liked.")
                    .font(.system(size: 12))
                    .foregroundColor(Color("SecondaryText"))
                    .lineLimit(2)
            }
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

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
