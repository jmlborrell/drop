//
//  LinkedListTests.swift
//  dropTests
//
//  Created by Jose Borrell on 2019-05-31.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import XCTest
@testable import drop

class NodeTest: XCTestCase {

    let node : Node<String> = Node(value: "Test")

    func testInitValue() {
        let string : String = "Test"
        XCTAssertEqual(node.value, string)
    }

    func testInitNext() {
        XCTAssertNil(node.next)
    }

    func testInitPrevious() {
        XCTAssertNil(node.previous)
    }
}

class LinkedListTests: XCTestCase {
    var testList : LinkedList<String>!

    override func setUp() {
        testList = LinkedList<String>()
    }

    func testInit() {
        self.setUp()
        XCTAssertTrue(testList.isEmpty())
    }

    func testStartWhenEmptyError() {
        self.setUp()
        let start : Result<Node<String>,LinkedListError> = testList.start()

        do {
            _ = try start.get()
            XCTFail("LinkedList is empty thus start should be nil")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("LinkedList error should be LinkedListError.empty")
        }
    }

    func testCurrentWhenEmptyError() {
        self.setUp()
        let current : Result<Node<String>,LinkedListError> = testList.current()

        do {
            _ = try current.get()
            XCTFail("LinkedList is empty thus current should be nil")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("LinkedList error should be LinkedListError.empty")
        }
    }

    func testLastWhenEmptyError() {
        self.setUp()
        let last : Result<Node<String>,LinkedListError> = testList.last()

        do {
            _ = try last.get()
            XCTFail("LinkedList is empty thus last should be nil")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("Error should be LinkedListError.empty")
        }
    }

    func testLengthWhenEmpty() {
        self.setUp()

        let length : Int = testList.length()
        let expected : Int = 0
        XCTAssertEqual(expected, length)
    }

    func testAppendWhenEmpty() {
        self.setUp()

        let expected: Int = 1
        let node = Node(value: "Test")
        testList.append(node: node)
        let length = testList.length()

        XCTAssertEqual(expected, length)
    }

    func testPrependWhenEmpty() {
        self.setUp()

        let expected: Int = 1
        let node = Node(value: "Test")
        testList.prepend(node: node)
        let length = testList.length()

        XCTAssertEqual(expected, length)
    }

    func testStartNotEmpty() {
        self.setUp()

        let node = Node(value: "Test")
        testList.append(node: node)

        do {
            let f = try testList.current().get()
            XCTAssertTrue(f === node)

        } catch {
            XCTFail("No error should be thrown")
        }
    }

    func testCurrentNotEmpty() {
        self.setUp()

        let node = Node(value: "Test")
        testList.append(node: node)

        do {
            let h = try testList.current().get()
            XCTAssertTrue(h === node)

        } catch {
            XCTFail("No error should be thrown")
        }
    }

    func testLastNotEmpty() {
        self.setUp()

        let node = Node(value: "Test")
        testList.append(node: node)

        do {
            let h = try testList.last().get()
            XCTAssertTrue(h === node)

        } catch {
            XCTFail("No error should be thrown")
        }
    }

    func testNextWhenEmptyError() {
        self.setUp()

        do {
            _ = try testList.next().get()
            XCTFail("Should throw LinkedListError.empty error")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("Threw wrong error")
        }
    }

    func testPreviousWhenEmptyError() {
        self.setUp()

        do {
            _ = try testList.previous().get()
            XCTFail("Should throw LinkedListError.empty error")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("Threw wrong error")
        }
    }

    func testNextOneItemError() {
        self.setUp()

        let node = Node(value: "Test")
        testList.append(node: node)

        do {
            _ = try testList.next().get()
            XCTFail("Should throw LinkedListError.last error")
        } catch LinkedListError.last {
            return
        } catch {
            XCTFail("Threw wrong error")
        }
    }

    func testNext() {
        self.setUp()

        let first = Node(value: "First")
        let node  = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: node)

        do {
            let n = try testList.next().get()
            XCTAssertTrue(n === node)

            let c = try testList.current().get()
            XCTAssertTrue(c === node)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }

    func testPreviousOneItemError() {
        self.setUp()

        let node = Node(value: "Test")
        testList.append(node: node)

        do {
            _ = try testList.previous().get()
            XCTFail("Should throw LinkedListError.first error")
        } catch LinkedListError.first {
            return
        } catch {
            XCTFail("Threw wrong error")
        }
    }

    func testPrevious() {
        self.setUp()

        let first = Node(value: "First")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: node)
        _ = testList.next()

        do {
            let p = try testList.previous().get()
            XCTAssertTrue(p === first)

            let c = try testList.current().get()
            XCTAssertTrue(c === first)
        } catch {
            XCTFail("Should not throw error")
        }
    }

    func testAppendWithOneItem() {
        self.setUp()

        let first = Node(value: "First")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: node)

        let expectedLength = 2
        let length = testList.length()

        XCTAssertEqual(expectedLength, length)

        let head = testList.current()
        let last = testList.last()

        do {
            let h = try head.get()
            XCTAssertTrue(h === first)

            let t = try last.get()
            XCTAssertTrue(t === node)
        } catch  {
            XCTFail("No Error should be thrown")
        }
    }

    func testPrependWithOneItem() {
        self.setUp()

        let first = Node(value: "First")
        let node = Node(value: "Test")

        testList.prepend(node: first)
        testList.prepend(node: node)

        let expectedLength = 2
        let length = testList.length()

        XCTAssertEqual(expectedLength, length)

        let head = testList.current()
        let last = testList.last()

        do {
            let h = try head.get()
            XCTAssertTrue(h === first)

            let t = try last.get()
            XCTAssertTrue(t === node)
        } catch  {
            XCTFail("No Error should be thrown")
        }
    }

    func testAppendWithTwoItems() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: node)

        let expectedLength = 3
        let length = testList.length()

        XCTAssertEqual(expectedLength, length)

        let head = testList.current()
        let last = testList.last()

        do {
            let h = try head.get()
            XCTAssertTrue(h === first)

            let t = try last.get()
            XCTAssertTrue(t === node)
        } catch  {
            XCTFail("No Error should be thrown")
        }
    }

    func testPrependWithTwoItems() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let node = Node(value: "Test")

        testList.prepend(node: first)
        testList.prepend(node: second)
        testList.prepend(node: node)

        let expectedLength = 3
        let length = testList.length()

        XCTAssertEqual(expectedLength, length)

        let head = testList.current()
        let last = testList.last()

        do {
            let h = try head.get()
            XCTAssertTrue(h === first)

            let t = try last.get()
            XCTAssertTrue(t === second)

            _ = testList.next()

            let c = try testList.current().get()
            XCTAssertTrue(c === node)

        } catch  {
            XCTFail("No Error should be thrown")
        }
    }

    func testReset() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        _ = testList.next()
        _ = testList.next()

        testList.reset()

        do {
            let s = try testList.start().get()
            XCTAssertTrue(s === first)
        } catch  {
            XCTFail("No Error should be thrown")
        }
    }

    func testClean() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")
        let expectedLength = 1

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        _ = testList.next()
        _ = testList.next()

        testList.clean()

        let length = testList.length()

        do {
            let s = try testList.start().get()
            XCTAssertTrue(s === third)
            XCTAssertEqual(expectedLength, length)
        } catch  {
            XCTFail("No Error should be thrown")
        }
    }

    func testFirstCurrentLast() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        _ = testList.next()

        do {
            let s = try testList.start().get()
            let c = try testList.current().get()
            let l = try testList.last().get()

            XCTAssertTrue(s === first)
            XCTAssertTrue(c === second)
            XCTAssertTrue(l === third)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }

    func testDelete() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        testList.delete()
        _ = testList.next()

        XCTAssertTrue(testList.isEmpty())
    }

    func testInsertLessThan0Error() {
        self.setUp()

        let node = Node(value: "Test")

        do {
            try testList.insert(at: -1, node: node)
            XCTFail("Should throw LinkedListError.outOfBounds")
        } catch LinkedListError.outOfBounds {
            return
        } catch {
            XCTFail("Threw wrong error")
        }
    }

    func testInsertEmpty0() {
        self.setUp()

        let node = Node(value: "Test")

        do {
            try testList.insert(at: 0, node: node)
        } catch {
            XCTFail("Should not throw error")
        }

        let length = testList.length()
        let expectedLength = 1

        XCTAssertEqual(expectedLength, length)

        do {
            let n = try testList.start().get()
            XCTAssertTrue(n === node)
        } catch  {
            XCTFail("Should not throw error")
        }
    }

    func testInsertEmptyError() {
        self.setUp()

        let node = Node(value: "Test")

        do {
            try testList.insert(at: 1, node: node)
            XCTFail("Should throw LinkedListError.empty")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("Threw wrong error")
        }
    }

    func testInsertNonEmpty0() {
        self.setUp()
        let first = Node(value: "First")
        let node = Node(value: "Test")

        testList.append(node: first)

        do {
            try testList.insert(at: 0, node: node)
        } catch {
            XCTFail("Error should not be thrown when inserting")
        }

        do {
            let n = try testList.current().get()
            XCTAssertTrue(n === node)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }

    func testInsertNonEmpty1() {
        self.setUp()

        let first = Node(value: "First")
        let node = Node(value: "Test")

        testList.append(node: first)

        do {
            try testList.insert(at: 1, node: node)
        } catch {
            XCTFail("Error should not be thrown")
        }

        do {
            let n = try testList.next().get()
            XCTAssertTrue(n === node)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }

    func testInsertNonEmptyEdge() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: second)

        do {
            try testList.insert(at: 2, node: node)
        } catch {
            XCTFail("Should not throw error")
        }

        do {
            let l = try testList.last().get()
            XCTAssertTrue(l === node)
        } catch {
            XCTFail("Should not throw error")
        }
    }

    func testInsertNonEmptyNonEdge() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        do {
            try testList.insert(at: 2, node: node)
        } catch {
            XCTFail("Should not throw error")
        }

        do {
            let l = try testList.last().get()
            XCTAssertTrue(l.previous === node)
        } catch {
            XCTFail("Should not throw error")
        }
    }

    func testInsertOutOfBoundsError() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        do {
            try testList.insert(at: 4, node: node)
            XCTFail("Should throw LinkedList.outOfBounds error")
        } catch {
            return
        }
    }

    func testInsert0WithPrevious() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let node = Node(value: "Test")

        testList.append(node: first)
        testList.append(node: second)
        _ = testList.next()

        do {
            try testList.insert(at: 0, node: node)
        } catch {
            XCTFail("Should not throw error")
        }

        do {
            let c = try testList.current().get()
            XCTAssertTrue(c.previous === first)
            XCTAssertTrue(c === node)
        } catch {
            XCTFail("Should not throw error")
        }
    }

    func deleteEmptyError() {
        self.setUp()

        do {
            try testList.delete(at: 0)
            XCTFail("Should have thrown error")
        } catch LinkedListError.empty {
            return
        } catch {
            XCTFail("Wrong error thrown")
        }
    }

    func deleteOnlyOneElement() {
        self.setUp()

        let first = Node(value: "First")
        testList.append(node: first)

        do {
            try testList.delete(at: 0)
            XCTAssertTrue(testList.isEmpty())
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func deleteNoNext() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")

        let expectedLength = 1

        testList.append(node: first)
        testList.append(node: second)

        do {
            try testList.delete(at: 1)
        } catch {
            XCTFail("Should not throw an error")
        }

        let length = testList.length()
        XCTAssertEqual(expectedLength, length)

        do {
            let t = try testList.last().get()
            XCTAssertTrue(t === first)
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func deleteNoPrevious() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")

        let expectedLength = 1

        testList.append(node: first)
        testList.append(node: second)

        do {
            try testList.delete(at: 0)
        } catch {
            XCTFail("Should not throw an error")
        }

        let length = testList.length()
        XCTAssertEqual(expectedLength, length)

        do {
            let c = try testList.current().get()
            XCTAssertTrue(c === second)
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func deleteMiddle() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")

        let expectedLength = 2

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        do {
            try testList.delete(at: 1)
        } catch {
            XCTFail("Should not throw an error")
        }

        let length = testList.length()
        XCTAssertEqual(expectedLength, length)

        do {
            let c = try testList.current().get()
            XCTAssertTrue(c === first)
        } catch {
            XCTFail("Should not throw an error")
        }

        do {
            let l = try testList.last().get()
            XCTAssertTrue(l === third)
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func deleteLessThan0Error() {
        self.setUp()

        do {
            try testList.delete(at: -1)
            XCTFail("Should throw LinkedListError.outOfBounds error")
        } catch LinkedListError.outOfBounds {
            return
        } catch {
            XCTFail("Wrong error thrown")
        }
    }

    func deleteOutOfBoundsError() {
        self.setUp()

        let first = Node(value: "First")
        let second = Node(value: "Second")
        let third = Node(value: "Third")

        testList.append(node: first)
        testList.append(node: second)
        testList.append(node: third)

        do {
            try testList.delete(at: 3)
            XCTFail("Should throw LinkedListError.outOfBounds error")
        } catch LinkedListError.outOfBounds {
            return
        } catch {
            XCTFail("Wrong error thrown")
        }
    }
}
