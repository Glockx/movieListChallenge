//
//  MovieModel.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Foundation

// MARK: - MoviesResult

struct MovieModel: Codable,Equatable {
    var adult: Bool?
    var backdropPath: String?
    var genreids: [Int]?
    var id: Int?
    var originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreids = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: MoviesResult convenience initializers and mutators

extension MovieModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MovieModel.self, from: data)
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
        adult: Bool?? = nil,
        backdropPath: String?? = nil,
        genreids: [Int]?? = nil,
        id: Int?? = nil,
        originalLanguage: String?? = nil,
        originalTitle: String?? = nil,
        overview: String?? = nil,
        popularity: Double?? = nil,
        posterPath: String?? = nil,
        releaseDate: String?? = nil,
        title: String?? = nil,
        video: Bool?? = nil,
        voteAverage: Double?? = nil,
        voteCount: Int?? = nil
    ) -> MovieModel {
        return MovieModel(
            adult: adult ?? self.adult,
            backdropPath: backdropPath ?? self.backdropPath,
            genreids: genreids ?? self.genreids,
            id: id ?? self.id,
            originalLanguage: originalLanguage ?? self.originalLanguage,
            originalTitle: originalTitle ?? self.originalTitle,
            overview: overview ?? self.overview,
            popularity: popularity ?? self.popularity,
            posterPath: posterPath ?? self.posterPath,
            releaseDate: releaseDate ?? self.releaseDate,
            title: title ?? self.title,
            video: video ?? self.video,
            voteAverage: voteAverage ?? self.voteAverage,
            voteCount: voteCount ?? self.voteCount
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try jsonData(), encoding: encoding)
    }
}
