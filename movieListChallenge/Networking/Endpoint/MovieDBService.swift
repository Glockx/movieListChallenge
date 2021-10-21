//
//  MovieDBService.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Foundation
import Moya

enum MovieDBService {
    case fetchMoviesGenres
    case fetchLatestMovies(page: Int)
    case searchMovie(query: String, page: Int)
    case getMovieDetails(movieID: Int)
}

extension MovieDBService: TargetType {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        switch self {
        case .fetchMoviesGenres:
            return "/genre/movie/list"
        case .fetchLatestMovies:
            return "/movie/now_playing"
        case .searchMovie:
            return "/search/movie"
        case .getMovieDetails:
            return "/movie"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchMoviesGenres, .fetchLatestMovies, .searchMovie, .getMovieDetails:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .fetchMoviesGenres:
            return .requestPlain
        case let .fetchLatestMovies(page: page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case let .searchMovie(query: query, page: page):
            return .requestParameters(parameters: ["query": query, "page": page], encoding: URLEncoding.queryString)
        case let .getMovieDetails(movieID: movieID):
            return .requestParameters(parameters: ["movie_id": movieID], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
