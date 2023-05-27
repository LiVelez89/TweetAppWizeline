//
//  FeedViewControllerTests.swift
//  TweetAppWizelineTests
//
//  Created by Lina on 24/05/23.
//

import XCTest
@testable import TweetAppWizeline

final class FeedViewControllerTests: XCTestCase {
    
    func test_createFeedViewController() {
        let sut = FeedViewController()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "TweetFeed")
        XCTAssertEqual(sut.view.backgroundColor, UIColor.white)
    }
    
    func test_createATableView() throws {
        let sut = FeedViewController()
        
        sut.loadViewIfNeeded()
        
        let tableView = sut.tableView
        let viewContainsTableView = try XCTUnwrap(sut.view?.subviews.contains(tableView))
        XCTAssert(viewContainsTableView)
    }
    
    func test_setupTableView_delegates() {
        let sut = FeedViewController()
        
        sut.loadViewIfNeeded()
        
        XCTAssert(sut.tableView.delegate is FeedViewController)
        XCTAssert(sut.tableView.dataSource is FeedViewController)
    }
    
    func test_createEmptyTableView_showNoCells() {
        let sut = FeedViewController()
        
        sut.loadViewIfNeeded()
        
        let tableView = sut.tableView
        XCTAssertEqual(0, tableView.numberOfRows(inSection: .zero))
    }
    
    func test_tableView_createsTweetCells() throws {
        let sut = FeedViewController()
        let dataManager = FeedDataManagerSpy()
        let dummyViewModel = FeedViewModel(title: "expectedTitle", dataManager: dataManager)
        
        sut.viewModel = dummyViewModel
        dataManager.result = .success([anyTweet()])
        
        sut.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        
        XCTAssert(cell is TweetCell)
    }
    
    func test_binding_showLoaderWhenFetchingTweets() {
        let sut = FeedViewController()
        
        sut.loadViewIfNeeded()
        sut.viewModel.observer.updateValue(with: .loading)
        
        let loader = sut.view.subviews.last
        XCTAssertTrue(loader is UIActivityIndicatorView)
    }
    
    func test_binding_hideLoaderOnFailedFetch() {
        // Given
        let sut = FeedViewController()
        
        // When
        sut.loadViewIfNeeded()
        sut.viewModel.observer.updateValue(with: .loading)
        sut.viewModel.observer.updateValue(with: .failure)
        
        // Then
        let loader = sut.view.subviews.last
        XCTAssertFalse(loader is UIActivityIndicatorView)
    }
    
    func test_binding_hideLoaderOnSuccessFetch() {
        // Given
        let sut = FeedViewController()
        
        // When
        sut.loadViewIfNeeded()
        sut.viewModel.observer.updateValue(with: .loading)
        sut.viewModel.observer.updateValue(with: .success)
        
        // Then
        let loader = sut.view.subviews.last
        XCTAssertFalse(loader is UIActivityIndicatorView)
    }
    
    func test_fetchTimeline_showAlertForFailedFetch() {
        let sut = FeedViewController()
        
        sut.loadViewIfNeeded()
        
        let navigation = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        let alert = navigation.viewControllers.first?.presentedViewController
        
        XCTAssertTrue(alert is UIAlertController, "Expected UIAlertController, got \(alert) insted.")
    }
    
    func test_fetchTimeline_reloadDataOnSuccessfulFetch() {
        let sut = FeedViewController()
        let dataManager = FeedDataManagerSpy()
        let dummyViewModel = FeedViewModel(title: "expectedTitle", dataManager: dataManager)
        
        sut.viewModel = dummyViewModel
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
        
        dataManager.result = .success([anyTweet()])
        sut.viewModel.fetchTimeline()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    // MARK: - Private helper methods
    private func anyTweet() -> TweetCellViewModel {
        TweetCellViewModel(userName: "any-name", profileName: "any-profile", profilePictureName: "cat", content: "any-content")
    }
    private class FeedDataManagerSpy: FeedDataManagerProtocol {
      
        var result: Result<[TweetCellViewModel], Error> = .success([])
        
        func fetch(completion: (Result<[TweetCellViewModel], Error>) -> Void) {
            completion(result)
        }
    }
}
