//
//  ChattingRoomCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChattingRoomCellViewModelInputs {
    func configure(with room: ChattingRoom)
}

protocol ChattingRoomCellViewModelOutputs {

}

protocol ChattingRoomCellViewModelType {
    var inputs: ChattingRoomCellViewModelInputs { get }
    var outputs: ChattingRoomCellViewModelOutputs { get }
}

final class ChattingRoomCellViewModel: ChattingRoomCellViewModelType,
ChattingRoomCellViewModelInputs, ChattingRoomCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ChattingRoomCellViewModelInputs { return self }
    var outputs: ChattingRoomCellViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<ChattingRoom> = PublishRelay()
    func configure(with room: ChattingRoom) {
        configureProperty.accept(room)
    }

    // MARK: - Outputs

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Functions
}
