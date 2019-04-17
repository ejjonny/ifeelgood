//
//  shrinkbotTests.swift
//  shrinkbotTests
//
//  Created by Ethan John on 4/15/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import XCTest
@testable import shrinkbot

class shrinkbotTests: XCTestCase {

	var insightGenerator: InsightGenerator!
	
    override func setUp() {
		super.setUp()
		insightGenerator = InsightGenerator()
    }

    override func tearDown() {
		super.tearDown()
		insightGenerator = nil
    }

    func testInsight() {
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
