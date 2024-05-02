//
//  TweetTextView.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 02/05/2024.
//

import UIKit
import Combine

class TweetTextView: UITextView {
    
    @Published var tweetText: String = ""
    @Published var characterCount: Int = 0
    @Published var remainingCount: Int = 280
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        $tweetText
            .map { TwitterText.lengthOf(tweet: $0) }
            .sink { [weak self] count in
                self?.characterCount = count
                self?.remainingCount = 280 - count
            }
            .store(in: &cancellables)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
    
    override var text: String! {
        didSet {
            updateCharacterCounts()
        }
    }
    
    private func updateCharacterCounts() {
        guard let text = self.text else { return }
        characterCount = TwitterText.lengthOf(tweet: text)
        remainingCount = 280 - characterCount
    }
}

extension TweetTextView: UITextViewDelegate {
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let currentText = textView.text as NSString
    let newText = currentText.replacingCharacters(in: range, with: text)
    return TwitterText.lengthOf(tweet: newText) <= 280
}
}
