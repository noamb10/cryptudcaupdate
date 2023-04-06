import Foundation

struct Transaction: Codable {
    let id: String
    let createdAt: String
    let amount: Double
    let asset: String
    let fee: Double
    let status: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case amount
        case asset
        case fee
        case status
        case type
    }
}
