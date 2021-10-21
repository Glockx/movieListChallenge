//
//  UpcomingMoviesModel.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Foundation

// MARK: - MoviesUpcomingModel

struct MoviesUpcomingModel: Codable,Equatable {
    var dates: MoviesDates?
    var page: Int?
    var results: [MovieModel]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: MoviesUpcomingModel convenience initializers and mutators

extension MoviesUpcomingModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MoviesUpcomingModel.self, from: data)
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
        dates: MoviesDates?? = nil,
        page: Int?? = nil,
        results: [MovieModel]?? = nil,
        totalPages: Int?? = nil,
        totalResults: Int?? = nil
    ) -> MoviesUpcomingModel {
        return MoviesUpcomingModel(
            dates: dates ?? self.dates,
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

// MARK: - MoviesDates

struct MoviesDates: Codable,Equatable {
    var maximum, minimum: String?
}

// MARK: MoviesDates convenience initializers and mutators

extension MoviesDates {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MoviesDates.self, from: data)
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
        maximum: String?? = nil,
        minimum: String?? = nil
    ) -> MoviesDates {
        return MoviesDates(
            maximum: maximum ?? self.maximum,
            minimum: minimum ?? self.minimum
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try jsonData(), encoding: encoding)
    }
}
