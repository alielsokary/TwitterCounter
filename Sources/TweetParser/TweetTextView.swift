//
//  TweetTextView.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 02/05/2024.
//

import UIKit
import Combine

public class TweetTextView: UITextView {
    // MARK: Properties
    @Published public var tweetText: String = ""
    @Published public var characterCount: Int = 0
    @Published public var remainingCount: Int = 280
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        $tweetText
            .map { TwitterText.lengthOf(tweet: $0) }
            .sink { [weak self] count in
                self?.characterCount = count
                self?.remainingCount = 280 - count
            }
            .store(in: &cancellables)
    }
    
    public func clearText() {
        tweetText = ""
        characterCount = 0
        remainingCount = 280
    }
}

// MARK: - UITextViewDelegate

extension TweetTextView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        return TwitterText.lengthOf(tweet: newText) <= 280
    }
}
