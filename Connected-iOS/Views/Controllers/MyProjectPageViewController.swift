//
//  MyProjectPageViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MyProjectPageViewController: UITableViewController {

    // MARK: - UI Properties

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: MyProjectPageViewModelType
    private let dataSource: BaseDataSource

    // MARK: - Lifecycle

    init(
        viewModel: MyProjectPageViewModelType,
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

    // TODO: - 테스트용 삭제
    private static var pageindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let label = UILabel()
        label.text = "PageViewController \(Self.pageindex)"
        Self.pageindex += 1
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    // MARK: - Functions

    private func bindViewModel() {

    }

    private func bindStyles() {

    }

    private func setUpLayout() {

    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.registerCell(MyProjectCell.self)

        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        self.refreshControl = refresh
    }

    @objc
    private func pullToRefresh(_ sender: UIRefreshControl) {
        viewModel.inputs.refresh()
    }
}