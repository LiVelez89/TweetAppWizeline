//
//  FeedViewModelTests.swift
//  TweetAppWizelineTests
//
//  Created by Lina on 27/05/23.
//

import XCTest
@testable import TweetAppWizeline

class FeedViewModelTests: XCTestCase {

    func test_setNotNilBindingObserver_stablishConnection() {
        //Given
        let sut = FeedViewModel()
        let exp = expectation(description: "Wait for bind")
        
        sut.observer.bind { state in
            //Then
            XCTAssertEqual(state, .loading)
            exp.fulfill()
        }
        //When
        sut.observer.updateValue(with: .loading)
        XCTAssertNil(sut.bind) 
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_setNilBindingToObserver_breaksConnection() {
        
        let sut = FeedViewModel()
        
        sut.observer.updateValue(with: .loading)
        XCTAssertNil(sut.bind)
    }
}
