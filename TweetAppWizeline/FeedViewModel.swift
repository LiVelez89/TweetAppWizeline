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
    
    let observer: Observer<FetchState> = Observer<FetchState>()
    
    init(title: String = "TweetFeed") {
        self.title = title
    }
}
