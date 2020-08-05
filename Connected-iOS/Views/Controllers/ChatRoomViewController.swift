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
        chatRoom: Chat.Room
    ) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        viewModel.outputs.addNewMessage()
            .emit(onNext: { [weak self] data in
                switch data {
                case .myMsg(let msg):
                    _ = 1
                case .counterpartMsg(let msg):
                    _ = 2
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white
    }

    private func setUpLayout() {

    }
}
