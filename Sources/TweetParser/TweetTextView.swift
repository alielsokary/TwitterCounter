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
    
    private var placeholderText = "Start typing! You can enter up to 280 characters"
    
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
}

// MARK: - UITextViewDelegate

extension TweetTextView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        return TwitterText.lengthOf(tweet: newText) <= 280
    }
}
