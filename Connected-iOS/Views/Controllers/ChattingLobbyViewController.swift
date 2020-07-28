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

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl = refresh
    }

    private func bindViewModel() {

    }

    private func bindStyles() {
        _ = baseRefreshControlStyle(refresh: refreshControl)
    }

    private func setUpLayout() {

    }

    @objc
    private func pullToRefresh(_ sender: UIRefreshControl) {
        viewModel.inputs.pullToRefresh()
    }
}
