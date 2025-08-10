import SwiftUI

struct ChannelsView: View {
    @StateObject var viewModel = ChannelsViewModel()
    @State private var showCreateChannel = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.channels) { channel in
                        VStack {
                            HStack {
                                Text(channel.name)
                                    .fontWeight(.semibold)
                                if channel.isPrivate {
                                    Image(systemName: "lock.fill")
                                }
                                Spacer()
                            }
                            .padding()
                            Divider()
                        }
                        .foregroundColor(Color("PrimaryText"))
                    }
                }
            }
            .navigationTitle("Channels")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateChannel.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("PrimaryText"))
                    }
                }
            }
            .sheet(isPresented: $showCreateChannel) {
                CreateChannelView()
            }
            .background(Color("PrimaryBackground"))
            .environment(\.colorScheme, .dark)
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
            }
        }
    }
}

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
