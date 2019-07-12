//
//  dropTests.swift
//  dropTests
//
//  Created by Jose Borrell on 2019-05-05.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import XCTest
import MediaPlayer
@testable import drop

class dropSongTests: XCTestCase {
    
    let songModel = SongModel()
    let viewModel = SongViewModel()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLibraryLength() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        setUp()
        XCTAssertEqual(viewModel.requestLibraryLength(), MPMediaQuery.songs().items?.count)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
