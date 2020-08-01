//
//  BaseCellTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/07/23.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
import Nimble
@testable import Connected_iOS

struct MockItem {

}

class MockCell: BaseCell {
    var viewModel: Int?

    func configureWith(with item: MockItem) {

    }

    func bindViewModel() {

    }

}

class BaseCellTests: XCTestCase {

    func testReusableId() {
        expect(MockCell.reusableId).to(equal("MockCell"))
    }

}
