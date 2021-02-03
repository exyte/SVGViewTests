//
//  TestResult.swift
//  SVGViewTests
//
//  Created by Yuriy Strot on 01.02.2021.
//

import Foundation

class TestResults {

    private static let instance = TestResults()

    private let entries: [SVGVersion: Set<String>]

    init() {
        let plistPath = Bundle.main.path(forResource: "TestResults", ofType: "plist")!
        let plistData = FileManager.default.contents(atPath: plistPath)!
        let plistDict = try! PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as! [String : AnyObject]

        var entries: [SVGVersion: Set<String>] = [:]
        for key in plistDict.keys {
            if let version = SVGVersion(rawValue: key), let list = plistDict[key] as? [String] {
                let entry = Set(list)
                entries[version] = entry
            }
        }
        self.entries = entries
    }

    static func isPassed(test: String, version: SVGVersion) -> Bool {
        return instance.entries[version]?.contains(test) ?? false
    }
}
