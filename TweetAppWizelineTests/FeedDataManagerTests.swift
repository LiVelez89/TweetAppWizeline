//
//  FeedDataManagerTests.swift
//  TweetAppWizelineTests
//
//  Created by Lina on 29/05/23.
//

import XCTest
@testable import TweetAppWizeline

class FeedDataManagerTests: XCTestCase {
    
    func testManager_success() {
        // Given
        let sut = FeedDataManager()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sut.session = URLSession(configuration: configuration)
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://gist.githubusercontent.com/ferdelarosa-wz/0c73ab5311c845fb7dfac4b62ab6c652/raw/6a39cffe68d87f1613f222372c62bd4e89ad06fa/tweets.json")
            return (
                .init(),
                mockData
            )
        }
        let expectation = self.expectation(description: "")
        
        // When
        sut.fetch { result in
            // Then
            switch result {
            case .success(let tweetCellViewModels):
                XCTAssertEqual(tweetCellViewModels.count, 1)
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testManager_failure() {
        let sut = FeedDataManager()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sut.session = URLSession(configuration: configuration)
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: "test", code: 0, userInfo: nil)
        }
        let expectation = self.expectation(description: "")
        sut.fetch { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "test")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFailureDecode() {
        let sut = FeedDataManager()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sut.session = URLSession(configuration: configuration)
        MockURLProtocol.requestHandler = { request in
            return (.init(), "".data(using: .utf8)!)
        }
        let expectation = self.expectation(description: "")
        sut.fetch { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                break
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Receive request with no handler")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
}

let mockData = """
                {
                "tweets": [
                {
                "created_at": "creation",
                "id_str": "id",
                "text": "This is an example",
                "user": {
                "name": "Wizeboot",
                "screen_name": "@wizeboot",
                "description": "description",
                "location": "location",
                "followers_count": 100,
                "created_at": "creation",
                "profile_background_color": "red",
                "profile_image_url": "url",
                "profile_background_image_url": "url"
                },
                "favorite_count": 100,
                "retweet_count": 10
                }
                ]
                }
                """.data(using: .utf8)!
