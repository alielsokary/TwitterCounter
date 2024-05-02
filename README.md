# TwitterCounter

[![iOS](https://github.com/alielsokary/TwitterCounter/actions/workflows/iOS.yml/badge.svg)](https://github.com/alielsokary/TwitterCounter/actions/workflows/iOS.yml)

I aimed for simplicity and a minimal design when designing the UI Component while also exploring the integration of Combine into the UI Component.

## Usage

```Swift
import TweetParser

@IBOutlet  private(set) weak  var  tweetTextView: TweetTextView!

    override  func  viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.$characterCount
        .map { "\($0)/280" }
        .assign(to: \.text, on: charactersTypedLabel)
        .store(in: &cancellables)

        tweetTextView.$remainingCount
        .map { "\($0)" }
        .assign(to: \.text, on: charactersRemainingLabel)
        .store(in: &cancellables)
}

```
