//
//  NetworkService.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case just
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .just: return "Just Error"
        }
    }
}

enum NetworkService {
    case signUp(email: String, password: String, nickname: String)
    case signIn(email: String, password: String)
    case projects
}

protocol NetworkServiceType {
    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>>
    func signIn(email: String, password: String) -> Single<Result<User, NetworkError>>
    func projects() -> Single<Result<[Project], NetworkError>>
}

class MockNetworkService: NetworkServiceType {
    func signIn(email: String, password: String) -> Single<Result<User, NetworkError>> {
        if email == "1" {
            return Single.just(.success(User(authToken: "auth-token-string")))
        } else {
            return Single.just(.failure(.just))
        }
    }

    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>> {
        if email == "1" {
            return Single.just(.success(User(authToken: "auth-token-string")))
        } else {
            return Single.just(.failure(.just))
        }
    }

    func projects() -> Single<Result<[Project], NetworkError>> {
        let items = [
            Project(id: 1, name: "project name1", thumbnailImageUrl: "", categories: ["개발", "카테"]),
            Project(id: 2, name: "name project2", thumbnailImageUrl: "", categories: ["디자인", "고리"]),
            Project(id: 3, name: "project name3", thumbnailImageUrl: "", categories: ["개발", "카테"]),
            Project(id: 4, name: "name project4", thumbnailImageUrl: "", categories: ["디자인", "고리"])
        ]

        let isSuccess: Bool = Int.random(in: 1...10) % 2 == 0
        if isSuccess { return Single.just(.success(items)) }
        return Single.just(.failure(NetworkError.just))
    }
}
