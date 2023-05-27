//
//  FeedViewModel.swift
//  TweetAppWizeline
//
//  Created by Lina on 24/05/23.
//

import UIKit

class FeedViewModel {
    let title: String
    var backgroundColor: UIColor? = .white
    
    var tweets: [TweetCellViewModel] = []
    
    let observer: Observer<FetchState> = Observer<FetchState>()
    let dataManager: FeedDataManagerProtocol
    
    var bind: ((FetchState?) -> Void)? {
        
        didSet {
            observer.bind(bind)
        }
    }
    
    init(title: String = "TweetFeed", dataManager: FeedDataManagerProtocol = FeedDataManager()) {
        self.title = title
        self.dataManager = dataManager
    }
    
    func fetchTimeline() {
        dataManager.fetch { result in
            switch result {
            case .success(let tweetsReturned):
                self.tweets = tweetsReturned
                observer.updateValue(with: .success)
            case .failure:
                observer.updateValue(with: .failure)
            }
        }
    }
}
