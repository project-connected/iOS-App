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
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { Chat.Message(roomId: 0, sender: 0, contents: "message") }
            .map { ChatMessageData.myMsg($0) }
            .bind(to: addNewMessageProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)

    }

    // MARK: - Functions
}
