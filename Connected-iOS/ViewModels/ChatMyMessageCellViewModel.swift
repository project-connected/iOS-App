//
//  ChatMyMessageCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/05.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol ChatMyMessageCellViewModelInputs {
    func configure(with: Chat.Message)
    func deinited()
}

protocol ChatMyMessageCellViewModelOutputs {
    func userName() -> Driver<String>
    func message() -> Driver<String>
}

protocol ChatMyMessageCellViewModelType {
    var inputs: ChatMyMessageCellViewModelInputs { get }
    var outputs: ChatMyMessageCellViewModelOutputs { get }
}

final class ChatMyMessageCellViewModel: ChatMyMessageCellViewModelType,
ChatMyMessageCellViewModelInputs, ChatMyMessageCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ChatMyMessageCellViewModelInputs { return self }
    var outputs: ChatMyMessageCellViewModelOutputs { return self }
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<Chat.Message> = PublishRelay()
    func configure(with item: Chat.Message) {
        configureProperty.accept(item)
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let userNameProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func userName() -> Driver<String> {
        return userNameProperty.asDriver()
    }

    private let messageProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func message() -> Driver<String> {
        return messageProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {
        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)

        configureProperty
            .map { $0.sender.nickname }
            .bind(onNext: { [weak self] in
                self?.userNameProperty.accept($0)
            })
            .disposed(by: disposeBag)

        configureProperty
            .map { $0.contents }
            .bind(onNext: { [weak self] in
                self?.messageProperty.accept($0)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
