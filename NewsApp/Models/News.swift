import Foundation
struct ApiResponse:Codable {
    let articles:[Article]
}

struct Article:Codable {
    let source:Source
    let title:String
    let url:String
    let urlToImage:String?
    let description:String
    let publishedAt:String
}

struct Source:Codable {
    let name:String
}
