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
    private let categoryCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: TagLayout(
            minimumLineSpacing: 1000,
            minimumInteritemSpacing: 10,
            sectionInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        )
    )

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ProjectThumbnailCellViewModelType? {
        didSet { bindViewModel() }
    }
    var imageLoader: ImageLoaderType?
    var dataSource: BaseDataSource? {
        didSet { configureCollectionView() }
    }

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

    private func configureCollectionView() {
        categoryCollectionView.registerCell(CategoryCell.self)
        categoryCollectionView.dataSource = dataSource
    }

    private func setUpLayout() {
        [thumbnailImageView, nameLabel, categoryCollectionView]
            .addArrangedSubviews(parent: stackView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        constraintViewToCenterInParent(parent: contentView, child: stackView)

        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),

            nameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),

            categoryCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50),

            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10)
        ])
    }

    private func bindStyles() {

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

        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.isScrollEnabled = false

        thumbnailImageView.contentMode = .scaleAspectFit
    }

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel?.inputs.deinited()
            })
            .disposed(by: disposeBag)

        viewModel?.outputs.projectName()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel?.outputs.projectThumbnailImageUrl()
            .drive(onNext: loadImage(with:))
            .disposed(by: disposeBag)

        viewModel?.outputs.projectCategories()
            .drive(onNext: { [weak self] categories in
                self?.dataSource?.set(
                    items: categories,
                    cellClass: CategoryCell.self,
                    section: 0
                )
                self?.categoryCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func configureWith(with item: Project) {
        viewModel?.inputs.configure(with: item)
    }

    private func loadImage(with url: String) {
        imageLoader?.setImage(imageView: thumbnailImageView, with: url, placeholder: #imageLiteral(resourceName: "Swift_logo_440px"))
    }
}
