//
//  UserInfoValidator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/30.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

protocol UserInfoValidatorType {
    func validateEmail(email: String) -> Bool
    func validatePassword(password: String) -> Bool
    func validateNickname(nickname: String) -> Bool
}

class UserInfoValidator: UserInfoValidatorType {

    // TODO: 이메일 유효성 검사 만들기
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // TODO: 비밀번호 유효성 검사 만들기
    func validatePassword(password: String) -> Bool {
        return password.count >= 6
    }

    // TODO: 닉네임 유효성 검사 만들기
    func validateNickname(nickname: String) -> Bool {
        return nickname.count > 2
    }
}
