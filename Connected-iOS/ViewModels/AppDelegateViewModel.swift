//
//  AppDelegateViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/20.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift

protocol AppDelegateViewModelInputs {

}

protocol AppDelegateViewModelOutputs {
    func currentUser() -> Observable<User?>
}

protocol AppDelegateViewModelType {
    var inputs: AppDelegateViewModelInputs { get }
    var outputs: AppDelegateViewModelOutputs { get }
}

final class AppDelegateViewModel: AppDelegateViewModelType, AppDelegateViewModelInputs, AppDelegateViewModelOutputs {

    var inputs: AppDelegateViewModelInputs { return self }
    var outputs: AppDelegateViewModelOutputs { return self }

    // MARK: - Inputs

    // MARK: - Outputs

    private let currentUserProperty: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    func currentUser() -> Observable<User?> {
        return currentUserProperty.asObservable()
    }

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Functions

}
