//
//  StubUserInfoValidator.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/08/02.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
@testable import Connected_iOS

class StubUserInfoValidator: UserInfoValidatorType {

    private let validateEmailBody: ((String) -> Bool)?
    private let validatePasswordBody: ((String) -> Bool)?
    private let validateNicknameBody: ((String) -> Bool)?

    init(
        validateEmailBody: ((String) -> Bool)? = nil,
        validatePasswordBody: ((String) -> Bool)? = nil,
        validateNicknameBody: ((String) -> Bool)? = nil
    ) {
        self.validateEmailBody = validateEmailBody
        self.validatePasswordBody = validatePasswordBody
        self.validateNicknameBody = validateNicknameBody
    }

    func validateEmail(email: String) -> Bool {
        return validateEmailBody!(email)
    }

    func validatePassword(password: String) -> Bool {
        return validatePasswordBody!(password)
    }

    func validateNickname(nickname: String) -> Bool {
        return validateNicknameBody!(nickname)
    }

}
