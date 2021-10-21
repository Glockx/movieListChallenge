//
//  MovieDetailsViewController.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/21.
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Views

    var simpleView = UIView()

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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        
        simpleView.backgroundColor = .systemOrange
        view.addSubview(simpleView)
    }

    // MARK: - viewWillDisappear

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        simpleView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}
