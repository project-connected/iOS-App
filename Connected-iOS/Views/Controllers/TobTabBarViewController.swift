//
//  TobTabBarViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TopTabBarDelegate: class {
    func topTabBarItemClicked(index: Int, item: TopTabBarItem)
}

final class TopTabBarViewController: UIViewController {

    // MARK: - UI Properties

    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: TopTabBarViewModelType
    weak var delegate: TopTabBarDelegate?
    private let dataSource: BaseDataSource

    // MARK: - Lifecycle

    init(
        viewModel: TopTabBarViewModelType,
        dataSource: BaseDataSource
    ) {
        self.viewModel = viewModel
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        configureCollectionView()
        setUpLayout()
        bindStyles()
        bindViewModel()

        viewModel.inputs.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {

        viewModel.outputs.tabBarItems()
            .drive(onNext: { items in
                self.dataSource.set(
                    items: items,
                    cellClass: TopTabBarCell.self,
                    section: 0
                )
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.notifyClickedItem()
            .emit(onNext: { self.delegate?.topTabBarItemClicked(index: $0.0, item: $0.1) })
            .disposed(by: disposeBag)

        viewModel.outputs.selectedItem()
            .drive(onNext: updateSelectedItem(index:))
            .disposed(by: disposeBag)
    }

    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.registerCell(TopTabBarCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            let width = UIScreen.main.bounds.width / 2
            layout.estimatedItemSize = CGSize(width: width, height: 55)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
        }
    }

    private func bindStyles() {
        view.backgroundColor = .white

        collectionView.backgroundColor = .white

    }

    private func setUpLayout() {
        [collectionView]
            .addSubviews(parent: view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func updateSelectedItem(index: Int) {
        (0..<dataSource.itemCountInSection(section: 0))
            .map { IndexPath(item: $0, section: 0) }
            .forEach { indexPath in
                let temp = self.collectionView.cellForItem(at: indexPath)
                guard let cell = temp as? TopTabBarCell else { return }
                cell.itemSelected(index: index)
            }
    }
}

extension TopTabBarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource[indexPath] as? (Int, TopTabBarItem) {
            viewModel.inputs.itemClicked(index: indexPath.item, item: item.1)
        }
    }
}
