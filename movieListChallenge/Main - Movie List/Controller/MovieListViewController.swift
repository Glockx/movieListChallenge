//
//  MovieListViewController.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import CollectionKit
import Combine
import CombineCocoa
import ComposableArchitecture
import Moya
import SnapKit
import UIKit

class MovieListViewController: UIViewController {
    // MARK: - Views

    var collectionView = CollectionView()
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Variables

    var viewStore = ViewStore(.init(initialState: MovieListState(), reducer: MovieListReducer, environment: MovieListEnvironment(mainQueue: .main, fetchUpcomingMovies: MovieService.getUpcomingMovies(page:), searchMovie: MovieService.searchMovie(query:))))
    var cancellables: Set<AnyCancellable> = []

    // Collection Kit Data Source
    let upcomingMoviesdataSource = ArrayDataSource(data: [MovieModel]()) { _, data in
        "\(data.id ?? Int.random(in: 0 ... 1000000000000))"
    }

    var searchArray = ArrayDataSource(data: [MovieModel]()) { _, data in
        "\(data.id ?? Int.random(in: 0 ... 1000000000000))"
    }

    // Collection Kit Provider
    var provider: BasicProvider<MovieModel, MovieCellView>!

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Navigation Bar Title
        title = "Latest Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        // Configure Collection View
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never

        // Configure Search Bar
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true

        // Add collection view to screen
        view.addSubview(collectionView)

        // Configure CollectionView
        provider = BasicProvider(
            dataSource: upcomingMoviesdataSource,
            viewSource: { (view: MovieCellView, data: MovieModel, _: Int) in
                view.configureView(model: data)
            },
            sizeSource: { (_, _, size) -> CGSize in
                CGSize(width: size.width, height: 150)
            },
            layout: FlowLayout(lineSpacing: 15),
            animator: AnimatedReloadAnimator(entryTransform: AnimatedReloadAnimator.fancyEntryTransform),
            tapHandler: { [weak self] context in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let movieDetailVC = MovieDetailsViewController(movieModel: context.data)
                    self.navigationController?.pushViewController(movieDetailVC, animated: true)
                }
            }
        )
        collectionView.provider = provider

        // Add Loading Activity
        view.addSubview(loadingIndicator)
        loadingIndicator.isHidden = true

        // Subscribe to upcoming movie items
        viewStore.publisher
            .map { $0.upcomingMovies }
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.upcomingMoviesdataSource.data = movies
            }.store(in: &cancellables)

        // Subscribe to item loading indicator value
        viewStore.publisher
            .map { $0.isLoadingUpcomingMoviesLoading }
            .sink { [weak self] isFetching in
                guard let self = self else { return }
                if isFetching {
                    self.loadingIndicator.isHidden = false
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.isHidden = true
                    self.loadingIndicator.stopAnimating()
                }
            }.store(in: &cancellables)

        // Observe Whether Collection View Reached Bottom With Offset
        collectionView.reachedBottomPublisher(offset: 300)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewStore.send(.increaseUpcomingMoviesCurrentPage(page: self.viewStore.state.upcomingMoviesCurrentPage + 1))
                self.viewStore.send(.fetchUpcomingMovies(page: self.viewStore.upcomingMoviesCurrentPage))
            }.store(in: &cancellables)
        
        // Map New Movie Search Results
        viewStore.publisher.map(\.searchResultMovies)
            .sink { [weak self] searchResult in
                guard let self = self else { return }
                self.searchArray.data = searchResult
            }.store(in: &cancellables)
        
        // Observe If User Is Searching
        viewStore.publisher.map(\.isSearching)
            .sink { [weak self] isSearching in
                guard let self = self else { return }
                if isSearching {
                    self.provider.dataSource = self.searchArray
                } else {
                    self.provider.dataSource = self.upcomingMoviesdataSource
                }
            }.store(in: &cancellables)

        // Send Fetch Movies
        viewStore.send(.fetchUpcomingMovies(page: 1))
    }

    // MARK: - viewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.navigationItem.searchController = self.searchController
        }
    }

    // MARK: - viewDidLayoutSubviews

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Constraint CollectionView
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        // Constraint Loading Indicator
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Search Bar Delegation

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewStore.send(.isSearching(searchController.isActive))
        if searchController.isActive {
            viewStore.send(.searchMovie(query: searchController.searchBar.text ?? ""))
        }
    }
}
