import XCTest
import Combine
@testable import TweetParser

final class TweetTextViewTests: XCTestCase {

    var textView: TweetTextView!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        let dummyCoder = NSKeyedUnarchiver(forReadingWith: Data())
        guard let tv = TweetTextView(coder: dummyCoder) else {
            XCTFail("Failed to initialize TweetTextView in setUp()")
            return
        }
        textView = tv
        textView.text = "Initial text"
    }

    override func tearDown() {
        textView = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testClearTextResetsTextViewProperties() {
        guard let tv = textView else {
            XCTFail("TweetTextView instance is nil in testClearText()")
            return
        }

        tv.clearText()
        XCTAssertEqual(tv.text, "")
        XCTAssertEqual(tv.tweetText, "")
        XCTAssertEqual(tv.characterCount, 0)
        XCTAssertEqual(tv.remainingCount, 280)
    }
}
