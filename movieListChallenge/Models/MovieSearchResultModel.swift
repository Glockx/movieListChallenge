//
//  MovieSearchResultModel.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/21.
//

import Foundation

// MARK: - MovieSearchResultModel

struct MovieSearchResultModel: Codable,Equatable {
    var page: Int?
    var results: [MovieModel]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: MovieSearchResultModel convenience initializers and mutators

extension MovieSearchResultModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MovieSearchResultModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        page: Int?? = nil,
        results: [MovieModel]?? = nil,
        totalPages: Int?? = nil,
        totalResults: Int?? = nil
    ) -> MovieSearchResultModel {
        return MovieSearchResultModel(
            page: page ?? self.page,
            results: results ?? self.results,
            totalPages: totalPages ?? self.totalPages,
            totalResults: totalResults ?? self.totalResults
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try jsonData(), encoding: encoding)
    }
}
