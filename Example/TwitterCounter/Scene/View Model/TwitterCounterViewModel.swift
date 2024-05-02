//
//  TwitterCounterViewModel.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 01/05/2024.
//

import Foundation
import Combine
import TweetParser

class TwitterCounterViewModel {
    
    @Published var tweetText: String = ""
    @Published var characterCount: Int = 0
    @Published var remainingCount: Int = 280
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $tweetText
            .map { TwitterText.lengthOf(tweet: $0) }
            .sink { [weak self] count in
                self?.characterCount = count
                self?.remainingCount = 280 - count
            }
            .store(in: &cancellables)
    }
}
