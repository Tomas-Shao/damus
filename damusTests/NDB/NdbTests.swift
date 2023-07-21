//
//  NDBIterTests.swift
//  damusTests
//
//  Created by William Casarin on 2023-07-21.
//

import XCTest
@testable import damus

final class NdbTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ndb_note() throws {
        let note = NdbNote.owned_from_json(json: test_contact_list_json)
        XCTAssertNotNil(note)
        guard let note else { return }

        let id = "20d0ff27d6fcb13de8366328c5b1a7af26bcac07f2e558fbebd5e9242e608c09"
        XCTAssertEqual(hex_encode(note.id), id)

        XCTAssertEqual(note.tags().reduce(0, { sum, _ in sum + 1 }), 786)
        XCTAssertEqual(note.tags().reduce(0, { sum, _ in sum + 1 }), 786)

        //let tags = note.tags()
        for tag in note.tags() {
            for elem in tag {
                print("test_ndb_iterator \(elem.string())")
            }
        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}