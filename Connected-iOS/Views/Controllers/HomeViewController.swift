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
    private let dataSource: HomeDataSource
    private let projectDetailViewControllerFactory: ProjectDetailViewController.Factory

    // MARK: - Lifecycle

    init(
        viewModel: HomeViewModelType,
        homeDataSource: HomeDataSource,
        projectDetailViewControllerFactory: ProjectDetailViewController.Factory
    ) {
        self.viewModel = viewModel
        self.dataSource = homeDataSource
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

        viewModel.outputs.themedProjects()
            .drive(onNext: { items in
                self.dataSource.set(
                    items: items,
                    cellClass: ProjectCollectionCell.self,
                    section: 0
                )
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showError()
            .emit(onNext: { error in
                self.dataSource.set(
                    items: [error],
                    cellClass: ErrorCell.self,
                    section: 0
                )
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.presentViewController()
            .map(viewController(from:))
            .emit(onNext: { self.navigationController?.pushViewController($0, animated: true) })
            .disposed(by: disposeBag)

        viewModel.outputs.loadingAnimated()
            .drive(refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white

        _ = baseRefreshControlStyle(refresh: refreshControl)
    }

    private func setUpLayout() {

    }

    private func configureTableView() {
        dataSource.cellDelegate = self
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.registerCell(ProjectCollectionCell.self)
        tableView.registerCell(ErrorCell.self)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh(refresh:)), for: .valueChanged)
        refreshControl = refresh
    }

    @objc func pullToRefresh(refresh: UIRefreshControl) {
        viewModel.inputs.refresh()
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
        viewModel.inputs.showProjectDetail(project: project)
    }
}
