import Foundation

public enum UserRole: String, Codable {
    case admin
    case employee
}

public struct User: Identifiable, Codable, Hashable {
    public let id: String
    public let fullname: String
    public let email: String
    public let username: String
    public var profileImageUrl: String?
    public var bio: String?
    public var organizationId: String?
    public var role: UserRole?

    public init(id: String, fullname: String, email: String, username: String, profileImageUrl: String? = nil, bio: String? = nil, organizationId: String? = nil, role: UserRole? = nil) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.bio = bio
        self.organizationId = organizationId
        self.role = role
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case email
        case username
        case profileImageUrl = "profile_image_url"
        case bio
        case organizationId = "organization_id"
        case role
    }
}
