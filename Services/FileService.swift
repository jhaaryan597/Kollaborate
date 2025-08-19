import Foundation

class FileService {
    static let shared = FileService()
    
    func uploadFile(data: Data, fileName: String, fileType: String) async throws -> String {
        // Upload file to backend and return URL
        return ""
    }
    
    func deleteFile(url: String) async throws {
        // Delete file from backend
    }
}
