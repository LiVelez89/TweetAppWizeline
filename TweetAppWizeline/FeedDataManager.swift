//
//  FeedDataManager.swift
//  TweetAppWizeline
//
//  Created by Lina on 27/05/23.
//

import Foundation

protocol FeedDataManagerProtocol {
    func fetch(completion: @escaping (Result<[TweetCellViewModel], Error>) -> Void)
}

class FeedDataManager: FeedDataManagerProtocol {
    
    var session = URLSession(configuration: .default)
    
    func fetch(completion: @escaping (Result<[TweetCellViewModel], Error>) -> Void) {
//        guard let url = URL(string: "https://gist.githubusercontent.com/ferdelarosa-wz/0c73ab5311c845fb7dfac4b62ab6c652/raw/6a39cffe68d87f1613f222372c62bd4e89ad06fa/tweets.json" ) else {
//            completion(.failure(NSError(domain: "Bad url", code: 1)))
//            return
//        }
        let url = URL(string: "https://gist.githubusercontent.com/ferdelarosa-wz/0c73ab5311c845fb7dfac4b62ab6c652/raw/6a39cffe68d87f1613f222372c62bd4e89ad06fa/tweets.json")!
        
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "Failed to fetch data", code: 2)))
                }
                return
            }
            self.decodeData(from: data, with: completion)
        }
        task.resume()
    }
    private func decodeData(from data: Data, with completion: @escaping (Result<[TweetCellViewModel], Error>) -> Void) {
        do {
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(TweetModel.self, from: data)
            let tweets = result.tweets
            
            var tweetCellArray: [TweetCellViewModel] = []
            
            for i in 0..<tweets.count {
                tweetCellArray.append(TweetCellViewModel(userName: tweets[i].user.name, profileName: tweets[i].user.screenName, profilePictureName: tweets[i].user.profileImageUrl, content: tweets[i].text))
            }
            completion(.success(tweetCellArray))
        } catch {
            completion(.failure(error))
        }
    }
}



