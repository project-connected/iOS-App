//
//  ChatRoomCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatRoomCellViewModelInputs {
    func configure(with room: ChatRoom)
}

protocol ChatRoomCellViewModelOutputs {
    func roomName() -> Driver<String>
    func numberOfParticipants() -> Driver<String>
    func lastMsg() -> Driver<String>
    func unconfirmedCount() -> Driver<String>
}

protocol ChatRoomCellViewModelType {
    var inputs: ChatRoomCellViewModelInputs { get }
    var outputs: ChatRoomCellViewModelOutputs { get }
}

final class ChatRoomCellViewModel: ChatRoomCellViewModelType,
ChatRoomCellViewModelInputs, ChatRoomCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ChatRoomCellViewModelInputs { return self }
    var outputs: ChatRoomCellViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<ChatRoom> = PublishRelay()
    func configure(with room: ChatRoom) {
        configureProperty.accept(room)
    }

    // MARK: - Outputs

    private let roomNameProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func roomName() -> Driver<String> {
        return roomNameProperty.asDriver()
    }

    private let numberOfParticipantsProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func numberOfParticipants() -> Driver<String> {
        return numberOfParticipantsProperty.asDriver()
    }

    private let lastMsgProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func lastMsg() -> Driver<String> {
        return lastMsgProperty.asDriver()
    }

    private let unconfirmedCountProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func unconfirmedCount() -> Driver<String> {
        return unconfirmedCountProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {
        let chatRoom = configureProperty

        chatRoom
            .map { "\($0.id) 일단 방 아이디" }
            .bind(to: roomNameProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
