//
//  MovieDetailsViewController.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/21.
//

import SnapKit
import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Views

    var containerView = UIView()

    // Poster Image
    lazy var posterImage: UIImageView = {
        var posterImage = UIImageView()
        posterImage.tintColor = .systemGray3
        posterImage.contentMode = .scaleAspectFit
        posterImage.clipsToBounds = true
        posterImage.sd_imageTransition = .fade(duration: 0.3)
        return posterImage
    }()

    // Movie Title Image
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 25)
        return titleLabel
    }()

    // Movie Description
    lazy var movieDescriptionLabel: UILabel = {
        let movieDescriptionLabel = UILabel()
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.textAlignment = .center
        movieDescriptionLabel.textColor = .white
        movieDescriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return movieDescriptionLabel
    }()

    // MARK: - Variables

    var movieModel: MovieModel!

    // MARK: - Init

    init(movieModel: MovieModel) {
        self.movieModel = movieModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Title
        title = movieModel.title
        // Hide Navigation Large Title
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white

        // Add Container View
        containerView.backgroundColor = .secondarySystemBackground
        view.addSubview(containerView)

        // Add Moview Poster
        containerView.addSubview(posterImage)

        // Add Title Label
        containerView.addSubview(titleLabel)
        
        // Add Movie Description Title
        containerView.addSubview(movieDescriptionLabel)

        // Configure Movie Details
        posterImage.sd_setImage(with: .init(string: "https://image.tmdb.org/t/p/w780\(movieModel.posterPath ?? "")")!) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            if let image = image {
                self.posterImage.image = image.sd_roundedCornerImage(withRadius: 10, corners: .allCorners, borderWidth: 0, borderColor: .none)
            }else{
                self.posterImage.image = .init(systemName: "photo.fill")
            }
        }
        titleLabel.text = movieModel.title
        movieDescriptionLabel.text = movieModel.overview
    }

    // MARK: - viewWillDisappear

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Constraint Container View
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        // Constraint Movie Poster
        posterImage.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(10)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        // Constarint Title Label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(10)
        }
        
        // Constarint Description Label
        movieDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
}
