import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testFinishAlertAfterFinishRoundWhenShow() {
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        sleep(2)
        
        let alert = app.alerts["Result Alert"]
        
        XCTAssertTrue(app.alerts["Result Alert"].exists)
        XCTAssertTrue(alert.label == "Раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testFinishAlertAfterFinishRoundWhenDismiss() {
        
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        sleep(2)
        
        let alert = app.alerts["Result Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(app.alerts["Result Alert"].exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
