//
//  NetworkService.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkService {
    case signUp(email: String, password: String, nickname: String)
}

protocol NetworkServiceType {
    func signUp(email: String, password: String, nickname: String) -> Single<User>
}

class MockNetworkService: NetworkServiceType {

    func signUp(email: String, password: String, nickname: String) -> Single<User> {
        if email == "1" {
            return Single.just(User(authToken: "auth-token-string"))
        } else {
            enum MockError: Error {
                case just
            }
            return Single.error(MockError.just)
        }
    }

}
