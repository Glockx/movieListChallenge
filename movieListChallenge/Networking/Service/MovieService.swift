//
//  MovieService.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Combine
import ComposableArchitecture
import Foundation
import Moya

class MovieService {
    // MARK: - Typealias

    typealias UpcomingMoviesListResponse = Effect<MoviesUpcomingModel, ErrorModel>
    typealias MovieSearchResponse = Effect<MovieSearchResultModel, ErrorModel>
    // API Key
    static var apiKey = (Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String) ?? ""
    // Provider
    static var provider = MoyaProvider<MovieDBService>(plugins: [AuthPlugin(token: apiKey)])

    // MARK: - Get Upcoming Movies

    static func getUpcomingMovies(page: Int = 1) -> UpcomingMoviesListResponse {
        return UpcomingMoviesListResponse.future { callback in
            provider.request(.fetchLatestMovies(page: page), callbackQueue: .main, progress: nil) { result in
                switch result {
                case let .success(response):

                    do {
                        let model = try MoviesUpcomingModel(data: response.data)
                        callback(.success(model))
                    } catch {
                        callback(.failure(.init(statusCode: 1, statusMessage: "Failed To Encode Model", success: false)))
                    }

                case .failure:
                    callback(.failure(.init(statusCode: 2, statusMessage: "Network Request Has Failed!", success: false)))
                }
            }
        }
    }

    // MARK: - Search For A Movie

    static func searchMovie(query: String) -> MovieSearchResponse {
        return MovieSearchResponse.future { callback in
            provider.request(.searchMovie(query: query, page: 1)) { result in
                switch result {
                case let .success(response):

                    do {
                        let model = try MovieSearchResultModel(data: response.data)
                        callback(.success(model))
                    } catch {
                        callback(.failure(.init(statusCode: 1, statusMessage: "Failed To Encode Model", success: false)))
                    }

                case .failure:
                    callback(.failure(.init(statusCode: 2, statusMessage: "Network Request Has Failed!", success: false)))
                }
            }
        }
    }
}
