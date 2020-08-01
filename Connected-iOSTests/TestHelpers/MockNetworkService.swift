//
//  MockNetworkService.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/08/01.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxTest
import RxSwift
import Nimble
@testable import Connected_iOS

class MockNetworkService: NetworkServiceType {

    private let signUpResult: Result<User, NetworkError>?
    private let signInResult: Result<User, NetworkError>?
    private let projectsResult: Result<[Project], NetworkError>?
    private let themedProjectsResult: Result<[ThemedProjects], NetworkError>?
    private let chatRoomsResult: Result<[ChatRoom], NetworkError>?

    init(
        signUpResult: Result<User, NetworkError>? = nil,
        signInResult: Result<User, NetworkError>? = nil,
        projectsResult: Result<[Project], NetworkError>? = nil,
        themedProjectsResult: Result<[ThemedProjects], NetworkError>? = nil,
        chatRoomsResult: Result<[ChatRoom], NetworkError>? = nil
    ) {
        self.signUpResult = signUpResult
        self.signInResult = signInResult
        self.projectsResult = projectsResult
        self.themedProjectsResult = themedProjectsResult
        self.chatRoomsResult = chatRoomsResult
    }

    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>> {
        return Single.just(self.signUpResult!)
    }

    func signIn(email: String, password: String) -> Single<Result<User, NetworkError>> {
        return Single.just(self.signInResult!)
    }

    func projects() -> Single<Result<[Project], NetworkError>> {
        return Single.just(self.projectsResult!)
    }

    func themedProjects() -> Single<Result<[ThemedProjects], NetworkError>> {
        return Single.just(self.themedProjectsResult!)
    }

    func chatRooms() -> Single<Result<[ChatRoom], NetworkError>> {
        return Single.just(self.chatRoomsResult!)
    }

}
