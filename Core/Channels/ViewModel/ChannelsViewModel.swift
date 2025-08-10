import Foundation

@MainActor
class ChannelsViewModel: ObservableObject {
    @Published var channels = [Channel]()

    init() {
        Task { try await fetchChannels() }
    }

    func fetchChannels() async throws {
        self.channels = try await ChannelService.shared.fetchChannels()
    }

    func createChannel(name: String, isPrivate: Bool) async throws {
        guard let createdBy = UserService.shared.currentUser?.id else { return }
        try await ChannelService.shared.createChannel(name: name, isPrivate: isPrivate, createdBy: createdBy)
    }
}
