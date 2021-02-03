//
//  TestSuite.swift
//  SVGViewTests
//
//  Created by Yuriy Strot on 24.01.2021.
//

import Foundation

class TestSuite: Hashable {

    static func getSuites(version: SVGVersion) -> [TestSuite] {
        var tests = [TestSuite]()
        var testMap = [String:TestSuite]()
        for test in TestCase.getTests(version: version).sorted(by: { $0.name < $1.name }) {
            if let splitIndex = test.name.firstIndex(of: "-") {
                let groupName = String(test.name[test.name.startIndex..<splitIndex])
                if let suit = testMap[groupName] {
                    suit.items.append(test)
                } else {
                    let newSuite = TestSuite(name: groupName, items: [test])
                    testMap[groupName] = newSuite
                    tests.append(newSuite)
                }
            }
        }
        return tests
    }

    static func == (lhs: TestSuite, rhs: TestSuite) -> Bool {
        return lhs.name == rhs.name
    }

    let name: String
    var items = [TestCase]()

    var passed: Int {
        items.filter { $0.passed }.count
    }

    init(name: String, items: [TestCase]) {
        self.name = name
        self.items = items
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
