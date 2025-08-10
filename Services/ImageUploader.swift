import Foundation
import Supabase
import UIKit

struct ImageUploader {
    static func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let filename = NSUUID().uuidString
        let path = "profile_images/\(filename)"
        
        do {
            let _ = try await supabase.storage
                .from("profile_images")
                .upload(path: path, file: imageData, options: FileOptions(contentType: "image/jpeg"))
            
            let urlResponse = try await supabase.storage
                .from("profile_images")
                .getPublicURL(path: path)
            
            return urlResponse.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
}
