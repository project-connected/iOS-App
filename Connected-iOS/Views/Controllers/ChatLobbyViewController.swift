//
//  ChatLobbyViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatLobbyViewController: UITableViewController {

    // MARK: - UI Properties

    private let refresh: UIRefreshControl = UIRefreshControl()

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: ChatLobbyViewModelType
    private let dataSource: BaseDataSource
    private weak var coordinator: ChatCoordinatorType?

    // MARK: - Lifecycle

    init(
        viewModel: ChatLobbyViewModelType,
        dataSource: BaseDataSource,
        coordinator: ChatCoordinatorType
    ) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        setUpLayout()
        bindStyles()
        bindViewModel()

        viewModel.inputs.viewDidLoad()
    }

    // MARK: - Functions

    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.registerCell(ChatRoomCell.self)
        tableView.registerCell(ErrorCell.self)
        tableView.rowHeight = 80

        refreshControl = refresh
    }

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        refresh.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.pullToRefresh()
            })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { [weak self] in self?.dataSource[$0] }
            .compactMap { $0 as? ChatRoom }
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.chatRoomClicked(chatRoom: $0)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.chatRooms()
            .drive(onNext: { rooms in
                self.dataSource.set(
                    items: rooms,
                    cellClass: ChatRoomCell.self,
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

        viewModel.outputs.showChatRoom()
            .emit(onNext: coordinator?.pushToChatRoom(chatRoom:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        _ = baseRefreshControlStyle(refresh: refresh)
    }

    private func setUpLayout() {

    }
}
