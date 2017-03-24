//
//  ReverseActionTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 21/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class ReverseActionTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = Scheduler()
    }
    
    func testReverseActionReportsSameDurationAsInnerAction() {
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { _ in} )
        let reversed = action.reversed()
        
        XCTAssertEqualWithAccuracy(action.duration, reversed.duration, accuracy: 0.001)
    }
    
    func testReverseActionStartsAtActionEnd() {
        
        var value = 0.5
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { value = $0 })
        let reversed = action.reversed()
        
        reversed.willBecomeActive()
        reversed.willBegin()
        reversed.update(t: 0.0)
        
        XCTAssertEqualWithAccuracy(value, 1.0, accuracy: 0.001)
    }
    
    func testReverseActionEndsAtActionStart() {
        
        var value = 0.5
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { value = $0 })
        let reversed = action.reversed()
        
        reversed.willBecomeActive()
        reversed.willBegin()
        reversed.update(t: 1.0)
        
        XCTAssertEqualWithAccuracy(value, 0.0, accuracy: 0.001)
    }
}
