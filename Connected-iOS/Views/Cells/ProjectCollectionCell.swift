//
//  ProjectCollectionCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProjectCollectionCellDelegate: class, Alertable {
    func showProjectDetail(project: Project)
}

class ProjectCollectionCell: UITableViewCell, BaseCell {

    // MARK: - UI Properties

    private let titleLabel: UILabel = UILabel()
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ProjectCollectionCellViewModelType?
    var dataSource: BaseDataSource?
    weak var delegate: ProjectCollectionCellDelegate?

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpLayout()
        bindStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func bindViewModel() {

        configureCollectionView()

        viewModel?.outputs.showProjectDetail()
            .emit(onNext: delegate?.showProjectDetail(project:))
            .disposed(by: disposeBag)

        viewModel?.outputs.projects()
            .drive(onNext: { items in
                self.dataSource?.set(items: items, cellClass: ProjectThumbnailCardCell.self, section: 0)
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel?.outputs.collectionTitle()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureWith(with themedProjects: ThemedProjects) {
        viewModel?.inputs.configure(with: themedProjects)
    }

    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.registerCell(ProjectThumbnailCardCell.self)
    }

    private func bindStyles() {

        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white

        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: contentView.bounds.width - 50, height: 400)
            layout.minimumLineSpacing = 50
            layout.sectionInset = UIEdgeInsets(top: 10, left: 25, bottom: 35, right: 25)
        }

    }

    private func setUpLayout() {
        [titleLabel, collectionView]
            .addSubviews(parent: contentView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([

            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),

            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 450),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension ProjectCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let project = dataSource?[indexPath] as? Project {
            viewModel?.inputs.projectClicked(project: project)
        }
    }
}
