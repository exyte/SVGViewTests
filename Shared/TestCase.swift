//
//  TestCase.swift
//  SVGViewTests
//
//  Created by Yuriy Strot on 24.01.2021.
//

import Foundation

class TestCase: Hashable {

    static func getTests(version: SVGVersion) -> [TestCase] {
        let root = Bundle.main.url(forResource: version.rawValue, withExtension: .none, subdirectory: "/w3c/")!
        var tests = [TestCase]()
        if let enumerator = FileManager.default.enumerator(at: root.appendingPathComponent("svg", isDirectory: true), includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! && fileURL.pathExtension == "svg" {
                        let name = fileURL.deletingPathExtension().lastPathComponent
                        let passed = TestResults.isPassed(test: name, version: version)
                        tests.append(TestCase(url: root, name: name, passed: passed))
                    }
                } catch { print(error, fileURL) }
            }
        }
        return tests
    }

    static func == (lhs: TestCase, rhs: TestCase) -> Bool {
        return lhs.url == rhs.url && lhs.name == rhs.name
    }

    let url: URL
    let name: String
    let passed: Bool

    init(url: URL, name: String, passed: Bool) {
        self.url = url
        self.name = name
        self.passed = passed
    }

    var svgURL: URL {
        return resolve("svg")
    }

    var pngURL: URL {
        return resolve("png")
    }

    private func resolve(_ type: String) -> URL {
        return url.appendingPathComponent(type).appendingPathComponent("\(name).\(type)")
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(name)
    }
}
