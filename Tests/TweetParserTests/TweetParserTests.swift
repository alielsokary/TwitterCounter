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
        textView.clearText()
        XCTAssertEqual(textView.text, "")
        XCTAssertEqual(textView.tweetText, "")
        XCTAssertEqual(textView.characterCount, 0)
        XCTAssertEqual(textView.remainingCount, 280)
    }
    
    func testTextChangeUpdatesCharactersCount() {
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "New text"
        
        let cancellable = textView.$characterCount
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        textView.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(textView.characterCount, 8)
        cancellable.cancel()
    }
    
    func testTextChangeUpdatesRemainingCount() {
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "New text"
        
        let cancellable = textView.$characterCount
            .dropFirst()
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        textView.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(textView.remainingCount, 272)
        cancellable.cancel()
    }
    
    func testTextChangeWithSpecialCharacterUpdatesCountCorrectly() {
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "℞"
        
        let cancellable = textView.$characterCount
            .dropFirst()
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        textView.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(textView.characterCount, 2)
        cancellable.cancel()
    }
    
    func testTextChangeWithEmojiCharactersUpdatesCountCorrectly() {
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "☺️☺️"
        
        let cancellable = textView.$characterCount
            .dropFirst()
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        textView.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(textView.characterCount, 8)
        cancellable.cancel()
    }
    
}
