import Foundation
import Supabase

class DocumentUploader {
    static let shared = DocumentUploader()
    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://qtqzmjavnlvdaivjgnzl.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0cXptamF2bmx2ZGFpdmpnbnpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NTc3OTgsImV4cCI6MjA3MDAzMzc5OH0.iDG2QyaTYPBOZCLAWkF4CtlvjoKDYDREiQuEsPppDKo"
    )

    func uploadDocument(from url: URL) async throws -> String? {
        let data = try Data(contentsOf: url)
        let fileName = url.lastPathComponent
        let response = try await client.storage.from("documents").upload(path: fileName, file: data)
        return response.path
    }
}
