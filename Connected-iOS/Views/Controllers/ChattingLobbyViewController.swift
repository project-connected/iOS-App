//
//  ChattingLobbyViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChattingLobbyViewController: UITableViewController {

    // MARK: - UI Properties

    private let refresh: UIRefreshControl = UIRefreshControl()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: ChattingLobbyViewModelType
    private let dataSource: BaseDataSource

    // MARK: - Lifecycle

    init(
        viewModel: ChattingLobbyViewModelType,
        dataSource: BaseDataSource
    ) {
        self.viewModel = viewModel
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        configureTableView()
        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputs.viewDidLoad()
    }

    // MARK: - Functions

    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.registerCell(ChattingRoomCell.self)
        tableView.registerCell(ErrorCell.self)

        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl = refresh
    }

    private func bindViewModel() {
        viewModel.outputs.chattingRooms()
            .drive(onNext: { rooms in
                self.dataSource.set(
                    items: rooms,
                    cellClass: ChattingRoomCell.self,
                    section: 0
                )
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showErrorMsg()
            .emit(onNext: { error in
                self.dataSource.set(
                    items: [error],
                    cellClass: ErrorCell.self,
                    section: 0
                )
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isRefreshing()
            .drive(refresh.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        _ = baseRefreshControlStyle(refresh: refresh)
    }

    private func setUpLayout() {

    }

    @objc
    private func pullToRefresh(_ sender: UIRefreshControl) {
        viewModel.inputs.pullToRefresh()
    }
}
