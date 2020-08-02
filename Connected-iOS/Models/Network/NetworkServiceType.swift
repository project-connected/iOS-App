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
    case themedProjects
    case chatRooms
}

protocol NetworkServiceType {
    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>>
    func signIn(email: String, password: String) -> Single<Result<User, NetworkError>>
    func projects() -> Single<Result<[Project], NetworkError>>
    func themedProjects() -> Single<Result<[ThemedProjects], NetworkError>>
    func chatRooms() -> Single<Result<[ChatRoom], NetworkError>>
}

class TestNetworkService: NetworkServiceType {
    func signIn(email: String, password: String) -> Single<Result<User, NetworkError>> {
        if email == "1" {
            return Single.just(.success(User(id: 1, authToken: "auth-token-string")))
        } else {
            return Single.just(.failure(.just))
        }
    }

    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>> {
        if email == "1" {
            return Single.just(.success(User(id: 1, authToken: "auth-token-string")))
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

        let isSuccess: Bool = Int.random(in: 1...100) <= 70
        if isSuccess { return Single.just(.success(items)) }
        return Single.just(.failure(NetworkError.just))
    }

    func themedProjects() -> Single<Result<[ThemedProjects], NetworkError>> {
        let items = [
            Project(id: 1, name: "project name1", thumbnailImageUrl: "",
                    categories: ["개발", "카테고리", "123", "abcdef", "개발", "카테고리", "123", "abcdef"]),
            Project(id: 2, name: "name project2", thumbnailImageUrl: "", categories: ["디자인", "카테고리", "123", "abcdef"]),
            Project(id: 3, name: "project name3", thumbnailImageUrl: "", categories: ["개발", "카테"]),
            Project(id: 4, name: "name project4", thumbnailImageUrl: "",
                    categories: ["디자인 dj2ioxamjicmewoafjioewcfmoiwefjewafjieowfaiwejiowmj", "고리"])
        ]

        let themedProjects = [
            ThemedProjects(theme: "인기 있는", projects: items),
            ThemedProjects(theme: "마감 임박", projects: items)
        ]

        let isSuccess: Bool = Int.random(in: 1...100) <= 70
        if isSuccess { return Single.just(.success(themedProjects)) }
        return Single.just(.failure(NetworkError.just))
    }

    func chatRooms() -> Single<Result<[ChatRoom], NetworkError>> {
        let rooms = [ChatRoom(id: 1), ChatRoom(id: 2)]
        return Single.just(.success(rooms))
    }
}
