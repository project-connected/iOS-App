//
//  ProjectThumbnailCardCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProjectThumbnailCardCell: UICollectionViewCell, BaseCell {

    // MARK: - UI Properties

    private let stackView: UIStackView = UIStackView()
    private let nameLabel: UILabel = UILabel()
    private let thumbnailImageView: UIImageView = UIImageView()
    private let categoriesLabel: UILabel = UILabel()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ProjectThumbnailCellViewModelType?
    var imageLoader: ImageLoaderType?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpLayout()
        bindStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setUpLayout() {
        [thumbnailImageView, nameLabel, categoriesLabel]
            .addArrangedSubviews(parent: stackView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),

            nameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),

            categoriesLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            categoriesLabel.heightAnchor.constraint(equalToConstant: 50),

            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -50),
            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -50)
        ])
    }

    private func bindStyles() {

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 10, height: 10)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 12
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true

        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        nameLabel.textColor = .black
        nameLabel.backgroundColor = .white

        categoriesLabel.textColor = .black
        categoriesLabel.backgroundColor = .white
    }

    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        viewModel.outputs.projectName()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.projectThumbnailImageUrl()
            .drive(onNext: loadImage(with:))
            .disposed(by: disposeBag)

        viewModel.outputs.projectCategories()
            .map { $0.joined() }
            .drive(categoriesLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureWith(with item: Project) {
        viewModel?.inputs.configure(with: item)
    }

    private func loadImage(with url: String) {
        imageLoader?.setImage(imageView: thumbnailImageView, with: url, placeholder: #imageLiteral(resourceName: "outline_home_black_36pt"))
    }
}
