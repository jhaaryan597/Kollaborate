import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: Text("Likes")) {
                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                        Text("Likes")
                            .foregroundColor(Color("PrimaryText"))
                    }
                }
                
                NavigationLink(destination: Text("Follows")) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.blue)
                        Text("Follows")
                            .foregroundColor(Color("PrimaryText"))
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
            }
            .background(Color("PrimaryBackground"))
        }
        .environment(\.colorScheme, .dark)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
