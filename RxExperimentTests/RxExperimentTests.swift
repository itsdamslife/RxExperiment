//
//  RxExperimentTests.swift
//  RxExperimentTests
//
//  Created by Damodar Shenoy on 12/24/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import XCTest
@testable import RxExperiment
import RxSwift
import RxTest

class RxExperimentTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let buttonTaps = self.scheduler.createHotObservable([
            next(100, ()),
            next(200, ()),
            next(300, ())
            ])
        let results = scheduler.createObserver(Int.self)
        
        let eventProvider = BtnEventProvider(buttonTapped: buttonTaps.asObservable())
        let presenter = CountPresenter(eventProvider: eventProvider)
        
        self.scheduler.scheduleAt(0) {
            presenter.count.subscribe(results).addDisposableTo(self.disposeBag)
        }
        scheduler.start()
        
        let expected = [
            next(100, 1),
            next(200, 2),
            next(300, 3)
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    
    
}
