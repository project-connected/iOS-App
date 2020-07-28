//
//  ChattingLobbyViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChattingLobbyViewModelInputs {
    func viewDidLoad()
    func pullToRefresh()
}

protocol ChattingLobbyViewModelOutputs {

}

protocol ChattingLobbyViewModelType {
    var inputs: ChattingLobbyViewModelInputs { get }
    var outputs: ChattingLobbyViewModelOutputs { get }
}

final class ChattingLobbyViewModel: ChattingLobbyViewModelType,
ChattingLobbyViewModelInputs, ChattingLobbyViewModelOutputs {

    // MARK: - Properties

    var inputs: ChattingLobbyViewModelInputs { return self }
    var outputs: ChattingLobbyViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        viewDidLoadProperty.accept(Void())
    }

    private let pullToRefreshProperty: PublishRelay<Void> = PublishRelay()
    func pullToRefresh() {
        pullToRefreshProperty.accept(Void())
    }

    // MARK: - Outputs

    // MARK: - Lifecycle

    init(
        networkService: NetworkServiceType
    ) {
        self.networkService = networkService

    }

    // MARK: - Functions
}
