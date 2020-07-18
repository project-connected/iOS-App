//
//  AnalyticsService.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Firebase

protocol AnalyticsService {
    static func configure()
}

extension FirebaseApp: AnalyticsService { }
