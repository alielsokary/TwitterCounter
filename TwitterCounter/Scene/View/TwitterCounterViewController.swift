//
//  TwitterCounterViewController.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 01/05/2024.
//

import UIKit


class TwitterCounterViewController: UIViewController {
    
    @IBOutlet private(set) weak var charactersTypedLabel: UILabel!
    @IBOutlet private(set) weak var charactersRemainingLabel: UILabel!
    
    @IBOutlet private(set) weak var tweetTextView: UITextView!
    
    @IBOutlet private(set) weak var copyTextButton: UIButton!
    @IBOutlet private(set) weak var clearTextButton: UIButton!
    
    @IBOutlet private(set) weak var postTweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        updateCharacterCount()
    }
    
    func updateCharacterCount() {
        let tweetText = tweetTextView.text ?? ""
        let characterCount = TwitterText.lengthOf(tweet: tweetText)
        let remainingCount = 280 - characterCount
        charactersTypedLabel.text = "\(characterCount)\\280"
        charactersRemainingLabel.text = "\(remainingCount)"
    }
}

extension TwitterCounterViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        if TwitterText.lengthOf(tweet: newText) > 280 {
            return false
        }
        return true
    }
}

