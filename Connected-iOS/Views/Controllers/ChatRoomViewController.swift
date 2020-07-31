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

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: ChatRoomViewModelType

    // MARK: - Lifecycle

    init(
        viewModel: ChatRoomViewModelType,
        chatRoom: ChatRoom
    ) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.inputs.deinited()
    }

    // MARK: - Functions

    private func bindViewModel() {

    }

    private func bindStyles() {
        view.backgroundColor = .white
    }

    private func setUpLayout() {

    }
}
