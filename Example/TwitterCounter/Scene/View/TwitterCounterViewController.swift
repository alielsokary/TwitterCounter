//
//  TwitterCounterViewController.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 01/05/2024.
//

import UIKit
import Combine
import TweetParser

class TwitterCounterViewController: UIViewController {
    // MARK: Properties
    @IBOutlet private(set) weak var charactersTypedLabel: UILabel!
    @IBOutlet private(set) weak var charactersRemainingLabel: UILabel!
    
    @IBOutlet private(set) weak var tweetTextView: TweetTextView!
    
    @IBOutlet private(set) weak var copyTextButton: UIButton!
    @IBOutlet private(set) weak var clearTextButton: UIButton!
    
    @IBOutlet private(set) weak var postTweetButton: UIButton!
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBindings()
    }
}

// MARK: - Configurations

private extension TwitterCounterViewController {
    
    func configureUI() {
        tweetTextView.layer.cornerRadius = 12.0
        tweetTextView.layer.borderWidth = 1.0
        tweetTextView.layer.borderColor = UIColor(named: "border-color")?.cgColor
    }
    
    func setupBindings() {
        tweetTextView.$characterCount
            .map { "\($0)/280" }
            .assign(to: \.text, on: charactersTypedLabel)
            .store(in: &cancellables)

        tweetTextView.$remainingCount
            .map { "\($0)" }
            .assign(to: \.text, on: charactersRemainingLabel)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: tweetTextView)
            .compactMap { ($0.object as? UITextView)?.text }
            .assign(to: \.tweetText, on: tweetTextView)
            .store(in: &cancellables)
    }
}

// MARK: - Actions

private extension TwitterCounterViewController {

    @IBAction func copyAction(_ sender: UIButton) {
        guard let text = tweetTextView.text else { return }
        UIPasteboard.general.string = text
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        tweetTextView.clearText()
    }
    
    @IBAction func postTweetAction(_ sender: UIButton) {
        
    }
}
