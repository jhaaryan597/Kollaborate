import Foundation
import Supabase

class ChannelService {
    static let shared = ChannelService()
    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://qtqzmjavnlvdaivjgnzl.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0cXptamF2bmx2ZGFpdmpnbnpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NTc3OTgsImV4cCI6MjA3MDAzMzc5OH0.iDG2QyaTYPBOZCLAWkF4CtlvjoKDYDREiQuEsPppDKo"
    )

    func createChannel(name: String, isPrivate: Bool, createdBy: String) async throws {
        let channel = Channel(id: UUID().uuidString, name: name, isPrivate: isPrivate, createdBy: createdBy, members: [createdBy])
        let response = try await client.database.from("channels").insert(channel).execute()
        print(response)
    }

    func fetchChannels() async throws -> [Channel] {
        let response: [Channel] = try await client.database.from("channels").select().execute().value
        return response
    }
}
