//
//  TwitterCounterViewController.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 01/05/2024.
//

import UIKit
import Combine

class TwitterCounterViewController: UIViewController {
    // MARK: Properties
    @IBOutlet private(set) weak var charactersTypedLabel: UILabel!
    @IBOutlet private(set) weak var charactersRemainingLabel: UILabel!
    
    @IBOutlet private(set) weak var tweetTextView: UITextView!
    
    @IBOutlet private(set) weak var copyTextButton: UIButton!
    @IBOutlet private(set) weak var clearTextButton: UIButton!
    
    @IBOutlet private(set) weak var postTweetButton: UIButton!
    
    private var viewModel = TwitterCounterViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        setupBindings()
    }
}

// MARK: - Configurations

private extension TwitterCounterViewController {
    func configureTextView() {
        tweetTextView.delegate = self
    }
    
    func setupBindings() {
        viewModel.$characterCount
            .map { "\($0)/280" }
            .assign(to: \.text, on: charactersTypedLabel)
            .store(in: &cancellables)

        viewModel.$remainingCount
            .map { "\($0)" }
            .assign(to: \.text, on: charactersRemainingLabel)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: tweetTextView)
            .compactMap { ($0.object as? UITextView)?.text }
            .assign(to: \.tweetText, on: viewModel)
            .store(in: &cancellables)
    }
}

// MARK: - UITextViewDelegate

extension TwitterCounterViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        if TwitterText.lengthOf(tweet: newText) > 280 {
            return false
        }
        return true
    }
}

