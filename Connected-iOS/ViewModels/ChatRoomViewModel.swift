//
//  ChatRoomViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/29.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum ChatMessageData {
    case myMsg(Chat.Message)
    case counterpartMsg(Chat.Message)
}

protocol ChatRoomViewModelInputs {
    func viewDidLoad()
    func deinited()
}

protocol ChatRoomViewModelOutputs {
    func messages() -> Driver<[ChatMessageData]>
    func addNewMessage() -> Signal<ChatMessageData>
}

protocol ChatRoomViewModelType {
    var inputs: ChatRoomViewModelInputs { get }
    var outputs: ChatRoomViewModelOutputs { get }
}

final class ChatRoomViewModel: ChatRoomViewModelType,
ChatRoomViewModelInputs, ChatRoomViewModelOutputs {

    // MARK: - Properties

    var inputs: ChatRoomViewModelInputs { return self }
    var outputs: ChatRoomViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        viewDidLoadProperty.accept(Void())
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let messagesProperty: BehaviorRelay<[ChatMessageData]> = BehaviorRelay(value: [])
    func messages() -> Driver<[ChatMessageData]> {
        return messagesProperty.asDriver()
    }

    private let addNewMessageProperty: PublishRelay<ChatMessageData> = PublishRelay()
    func addNewMessage() -> Signal<ChatMessageData> {
        return addNewMessageProperty.asSignal()
    }

    // MARK: - Lifecycle

    init(
        networkService: NetworkServiceType
    ) {
        self.networkService = networkService

        viewDidLoadProperty
            .map { [
                Chat.Message(roomId: 0, sender: (0, "user"), contents: "있던 메세지1"),
                Chat.Message(roomId: 0, sender: (0, "user2"), contents: "있던 메세지2")
                ] }
            .map({
                $0.enumerated().map({ index, msg in
                    index % 2 == 0 ? ChatMessageData.myMsg(msg) : ChatMessageData.counterpartMsg(msg)
                })
            })
            .bind(to: messagesProperty)
            .disposed(by: disposeBag)

        Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.instance)
            .scan(
                (0, Chat.Message(roomId: 0, sender: (0, "user"), contents: "추가 메세지")),
                accumulator: { initial, _ in (initial.0 + 1, initial.1) }
            )
            .map({ index, msg in
                index % 2 == 0 ? ChatMessageData.myMsg(msg) : ChatMessageData.counterpartMsg(msg)
            })
            .bind(to: addNewMessageProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)

    }

    // MARK: - Functions
}
