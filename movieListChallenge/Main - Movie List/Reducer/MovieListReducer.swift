//
//  MovieListReducer.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Combine
import ComposableArchitecture
import Foundation

struct MovieListState: Equatable {
    var upcomingMovies = [MovieModel]()
    var upcomingMoviesCurrentPage = 1
    var isLoadingUpcomingMoviesLoading = false
    var searchResultMovies = [MovieModel]()
    var isSearching = false
}

enum MovieListAction: Equatable {
    case fetchUpcomingMovies(page: Int)
    case upcomingMoviesFetched(Result<MoviesUpcomingModel, ErrorModel>)
    case increaseUpcomingMoviesCurrentPage(page: Int)
    case searchMovie(query: String)
    case searchMovieResult(Result<MovieSearchResultModel, ErrorModel>)
    case isSearching(Bool)
}

struct MovieListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetchUpcomingMovies: (Int) -> Effect<MoviesUpcomingModel, ErrorModel>
    var searchMovie: (String) -> Effect<MovieSearchResultModel, ErrorModel>
}

let MovieListReducer = Reducer<MovieListState, MovieListAction, MovieListEnvironment> { state, action, environment in
    switch action {
    // MARK: - Send Request Fetch Upcoming Movies

    case let .fetchUpcomingMovies(page: page):
        state.isLoadingUpcomingMoviesLoading = true
        return MovieService.getUpcomingMovies(page: state.upcomingMoviesCurrentPage).receive(on: environment.mainQueue).catchToEffect(MovieListAction.upcomingMoviesFetched)

    // MARK: - Movies Fetched Successfully

    case let .upcomingMoviesFetched(.success(model)):
        // Hide loading indicator
        state.isLoadingUpcomingMoviesLoading = false
        // Append New Movies
        state.upcomingMovies.append(contentsOf: model.results ?? [])
        // Filter Duplicate Movies
        state.upcomingMovies = state.upcomingMovies.unique(for: \.id)
        return .none

    // MARK: - Movies failed to fetch

    case .upcomingMoviesFetched(.failure):
        state.isLoadingUpcomingMoviesLoading = false
        return .none

    // MARK: - Increase Paginating Number

    case let .increaseUpcomingMoviesCurrentPage(page: page):
        state.upcomingMoviesCurrentPage = page
        return .none

    // MARK: - Movie Search

    case let .searchMovie(query):
        if query.isEmpty {
            state.searchResultMovies = state.upcomingMovies
            return .none
        } else {
            return environment.searchMovie(query).receive(on: environment.mainQueue).catchToEffect(MovieListAction.searchMovieResult)
        }

    case let .searchMovieResult(.success(model)):
        state.searchResultMovies = model.results ?? []
        return .none

    case .searchMovieResult(.failure):
        return .none

    // MARK: - Is Searching

    case let .isSearching(isSearching):
        state.isSearching = isSearching
        return .none
    }
}
