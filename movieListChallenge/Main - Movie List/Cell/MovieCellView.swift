//
//  MovieCellView.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/20.
//

import Moya
import SDWebImage
import SnapKit
import UIKit

class MovieCellView: UIView {
    // MARK: - Views

    lazy var backgroundImage: UIImageView = {
        var backgroundImage = UIImageView()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.backgroundColor = .systemBackground
        backgroundImage.layer.cornerRadius = 10
        backgroundImage.tintColor = .systemGray3
        backgroundImage.sd_imageTransition = .fade(duration: 0.3)
        backgroundImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        return backgroundImage
    }()

    lazy var overlay: UIView = {
        var overlay = UIView()
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.2)
        overlay.layer.cornerRadius = 10
        return overlay
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 22)
        return titleLabel
    }()

    lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.numberOfLines = 2
        subTitleLabel.textColor = .white
        subTitleLabel.font = .systemFont(ofSize: 16)
        return subTitleLabel
    }()

    lazy var cellIndicatorButton: UIButton = {
        let cellIndicator = UIButton()
        cellIndicator.tintColor = .white
        cellIndicator.setImage(.init(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)), for: .normal)
        return cellIndicator
    }()

    // MARK: - Variables

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        addSubview(overlay)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(cellIndicatorButton)
    }

    // MARK: -  Configure Model

    func configureView(model: MovieModel) {
        // Set Movie Title
        titleLabel.text = model.title
        // Set Movie Release Date
        subTitleLabel.text = "Release Date: " + (model.releaseDate ?? "N/A")
        // Set Moive Poster
        self.backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.sd_setImage(with: .init(string: "https://image.tmdb.org/t/p/w780\(model.posterPath ?? "")")!) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let image = image {
                    self.backgroundImage.contentMode = .scaleAspectFill
                    self.backgroundImage.image = image
                }else{
                    self.backgroundImage.contentMode = .scaleAspectFit
                    self.backgroundImage.image = .init(systemName: "photo.fill")
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        // Constraint Background Image
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
        // Constraint Overlay View
        overlay.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
        
        // Constraint Cell Indicator
        cellIndicatorButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.size.greaterThanOrEqualTo(25)
        }
        
        // Constraint Title Label
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading).inset(20)
            make.trailing.lessThanOrEqualTo(cellIndicatorButton.snp.leading)
        }

        // Constraint Subtitle Label
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }
        
      
    }
}
