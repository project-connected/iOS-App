//
//  SignUpViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

protocol SignUpViewModelInputs {

}

protocol SignUpViewModelOutputs {

}

protocol SignUpViewModelType {
    var inputs: SignUpViewModelInputs { get }
    var outputs: SignUpViewModelOutputs { get }
}

final class SignUpViewModel: SignUpViewModelType, SignUpViewModelInputs, SignUpViewModelOutputs {

    var inputs: SignUpViewModelInputs { return self }
    var outputs: SignUpViewModelOutputs { return self }

}
