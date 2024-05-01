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
        
    }


}

