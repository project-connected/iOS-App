//
//  ChatRoomViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/29.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatRoomViewController: UIViewController {

    // MARK: - UI Properties

    private let tableView: UITableView = UITableView()

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: ChatRoomViewModelType
    private let dataSource: BaseDataSource

    // MARK: - Lifecycle

    init(
        chatRoom: Chat.Room,
        viewModel: ChatRoomViewModelType,
        dataSource: BaseDataSource
    ) {
        self.viewModel = viewModel
        self.dataSource = dataSource

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

    private func bindViewModel() {
        self.rx.deallocated
            .bind(onNext: {[weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.messages()
            .drive(onNext: { [weak self] in
                self?.dataSource.set(items: [], cellClass: ChatMyMessageCell.self, section: 0)
                $0.forEach({ data in
                    switch data {
                    case .myMsg(let msg):
                        self?.dataSource.appendRow(item: msg, cellClass: ChatMyMessageCell.self, section: 0)
                    case .counterpartMsg(let msg):
                        self?.dataSource.appendRow(item: msg, cellClass: ChatCounterpartMessageCell.self, section: 0)
                    }
                })
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.addNewMessage()
            .emit(onNext: { [weak self] data in
                guard let `self` = self else { return }
                let index: IndexPath
                switch data {
                case .myMsg(let msg):
                    index = self.dataSource.appendRow(item: msg, cellClass: ChatMyMessageCell.self, section: 0)
                case .counterpartMsg(let msg):
                    index = self.dataSource.appendRow(item: msg, cellClass: ChatCounterpartMessageCell.self, section: 0)
                }
                self.tableView.insertRows(at: [index], with: .bottom)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white

        tableView.backgroundColor = .cyan
    }

    private func setUpLayout() {
        [tableView]
        .addSubviews(parent: view)
        .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.registerCell(ChatMyMessageCell.self)
        tableView.registerCell(ChatCounterpartMessageCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
    }
}
