//
//  HomeViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    // MARK: - UI Properties

    private let collectionView: UICollectionView

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModelType
    private let dataSource: BaseDataSource
    private let projectDetailViewControllerFactory: ProjectDetailViewController.Factory

    // MARK: - Lifecycle

    init(
        viewModel: HomeViewModelType,
        projectThumbnailDataSource: BaseDataSource,
        projectDetailViewControllerFactory: ProjectDetailViewController.Factory
    ) {
        self.viewModel = viewModel
        self.dataSource = projectThumbnailDataSource
        self.projectDetailViewControllerFactory = projectDetailViewControllerFactory

        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        setUpLayout()
        bindStyles()
        bindViewModel()
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {
        viewModel.outputs.showProjectDetail()
            .map { self.projectDetailViewControllerFactory.create(.init(project: $0)) }
            .emit(onNext: { self.navigationController?.pushViewController($0, animated: true) })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: view.bounds.width - 50, height: 400)
            layout.minimumLineSpacing = 50
            layout.sectionInset = UIEdgeInsets(top: 10, left: 25, bottom: 35, right: 25)
        }
    }

    private func setUpLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        constraintViewToCenterInViewController(parent: self, child: collectionView)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }

    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.registerCell(ProjectThumbnailCardCell.self)

        var items = [
            Project(id: 1, name: "project name", thumbnailImageUrl: "", categories: ["개발", "카테"]),
            Project(id: 2, name: "name project", thumbnailImageUrl: "", categories: ["디자인", "고리"])
        ]

        items += items

        dataSource.set(items: items, cellClass: ProjectThumbnailCardCell.self, section: 0)
    }

}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let project = dataSource[indexPath] as? Project {
            viewModel.inputs.projectClicked(project: project)
        }
    }
}
