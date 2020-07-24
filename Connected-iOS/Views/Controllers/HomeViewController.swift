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

final class HomeViewController: UITableViewController {

    // MARK: - UI Properties

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModelType
    private lazy var projectCollectionDataSource: BaseDataSource = {
        return self.projectCollectionDataSourceFactory.create(payload: .init(cellDelegate: self))
    }()
    private let projectCollectionDataSourceFactory: ProjectCollectionDataSource.Factory
    private let projectDetailViewControllerFactory: ProjectDetailViewController.Factory

    // MARK: - Lifecycle

    init(
        viewModel: HomeViewModelType,
        projectCollectionDataSourceFactory: ProjectCollectionDataSource.Factory,
        projectDetailViewControllerFactory: ProjectDetailViewController.Factory
    ) {
        self.viewModel = viewModel
        self.projectCollectionDataSourceFactory = projectCollectionDataSourceFactory
        self.projectDetailViewControllerFactory = projectDetailViewControllerFactory

        super.init(nibName: nil, bundle: nil)

        configureTableView()
        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.viewWillAppear()
    }

    // MARK: - Functions

    private func bindViewModel() {

        viewModel.outputs.projectSubjects()
            .drive(onNext: { items in
                self.projectCollectionDataSource.set(
                    items: items,
                    cellClass: ProjectCollectionCell.self,
                    section: 0
                )
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.presentViewController()
            .map(viewController(from:))
            .emit(onNext: { self.navigationController?.pushViewController($0, animated: true) })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white
    }

    private func setUpLayout() {

    }

    private func configureTableView() {
        tableView.dataSource = projectCollectionDataSource
        tableView.delegate = self
        tableView.registerCell(ProjectCollectionCell.self)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500

        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        refresh.addTarget(self, action: #selector(pullToRefresh(refresh:)), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc func pullToRefresh(refresh: UIRefreshControl) {
        viewModel.inputs.refresh()
        tableView.reloadData()
        refresh.endRefreshing()
    }

    private func viewController(from data: HomeViewControllerData) -> UIViewController {
        switch data {
        case .projectDatail(let project):
            return projectDetailViewControllerFactory.create(payload: .init(project: project))
        }
    }
}

// MARK: - ProjectCollectionCellDelegate

extension HomeViewController: ProjectCollectionCellDelegate {
    func showProjectDetail(project: Project) {
        print("show project detail delegate")
        viewModel.inputs.showProjectDetail(project: project)
    }
}
