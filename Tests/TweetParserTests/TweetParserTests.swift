import XCTest
import Combine
@testable import TweetParser

final class TweetTextViewTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testClearTextResetsTextViewProperties() {
        let sut = makeSUT()
        sut.clearText()
        XCTAssertEqual(sut.text, "")
        XCTAssertEqual(sut.tweetText, "")
        XCTAssertEqual(sut.characterCount, 0)
        XCTAssertEqual(sut.remainingCount, 280)
    }
    
    func testTextChangeUpdatesCharactersCount() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "New text"
        
        let cancellable = sut.$characterCount
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        sut.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.characterCount, 8)
        cancellable.cancel()
    }
    
    func testTextChangeUpdatesRemainingCount() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "New text"
        
        let cancellable = sut.$characterCount
            .dropFirst()
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        sut.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.remainingCount, 272)
        cancellable.cancel()
    }
    
    func testTextChangeWithSpecialCharacterUpdatesCountCorrectly() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "℞"
        
        let cancellable = sut.$characterCount
            .dropFirst()
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        sut.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.characterCount, 2)
        cancellable.cancel()
    }
    
    func testTextChangeWithEmojiCharactersUpdatesCountCorrectly() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Character count updated")
        let tweetText = "☺️☺️"
        
        let cancellable = sut.$characterCount
            .dropFirst()
            .sink { count in
                if count > 0 {
                    expectation.fulfill()
                }
            }
        
        sut.tweetText = tweetText
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.characterCount, 8)
        cancellable.cancel()
    }
    
}

// MARK: - Helpers
private extension TweetTextViewTests {
    func makeSUT() -> TweetTextView {
        let textView = TweetTextView(coder: mockCoder())!
        textView.text = "Initial text"
        return textView
    }
    
    func mockCoder() -> NSKeyedUnarchiver {
        let object = String()
        let data = try! NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)
        return coder
    }
}
