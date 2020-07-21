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

enum NetworkService {
    case signUp(email: String, password: String, nickname: String)
}

protocol NetworkServiceType {
    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>>
}

class MockNetworkService: NetworkServiceType {

    func signUp(email: String, password: String, nickname: String) -> Single<Result<User, NetworkError>> {
        if email == "1" {
            return Single.just(.success(User(authToken: "auth-token-string")))
        } else {
            return Single.just(.failure(.just))
        }
    }

}
