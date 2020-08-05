//
//  ChatCounterpartMessageCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/05.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol ChatCounterpartMessageCellViewModelInputs {
    func configure(with: Chat.Message)
    func deinited()
}

protocol ChatCounterpartMessageCellViewModelOutputs {

}

protocol ChatCounterpartMessageCellViewModelType {
    var inputs: ChatCounterpartMessageCellViewModelInputs { get }
    var outputs: ChatCounterpartMessageCellViewModelOutputs { get }
}

final class ChatCounterpartMessageCellViewModel: ChatCounterpartMessageCellViewModelType,
ChatCounterpartMessageCellViewModelInputs, ChatCounterpartMessageCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ChatCounterpartMessageCellViewModelInputs { return self }
    var outputs: ChatCounterpartMessageCellViewModelOutputs { return self }
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

    // MARK: - Lifecycle

    init() {

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
