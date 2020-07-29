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

protocol ChatRoomViewModelInputs {

}

protocol ChatRoomViewModelOutputs {

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
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Lifecycle

    init(
        networkService: NetworkServiceType
    ) {
        self.networkService = networkService

    }

    // MARK: - Functions
}
