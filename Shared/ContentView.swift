//
//  ContentView.swift
//  Shared
//
//  Created by Yuriy Strot on 23.01.2021.
//

import SwiftUI
import SVGView

struct ContentView: View {

    var body: some View {
        TabView {
            TestSuitesView(suits: TestSuite.getSuites(version: .SVG11Full)).tabItem {
                Image(systemName: "11.circle")
                Text("1.1 F2")
            }
            TestSuitesView(suits: TestSuite.getSuites(version: .SVG12Tiny)).tabItem {
                Image(systemName: "12.circle")
                Text("1.2 T")
            }
        }
    }

}

struct TestSuitesView: View {

    let suits: [TestSuite]

    var body: some View {
        NavigationView {
            List {
                ForEach(suits, id: \.self) { suit in
                    TestSuitView(suit: suit)
                }
            }
            .updateNavigationBarTitle("SVG")
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct TestSuitView: View {

    let suit: TestSuite

    @State var expanded = false

    var body: some View {
        Section(header: getHeader()) {
            ForEach(expanded ? suit.items : [], id: \.self) { test in
                NavigationLink(destination: TestCaseView(test: test)) {
                    Text(test.name)
                }
            }
        }
    }

    func getHeader() -> some View {
        Text("\(suit.name) (\(suit.items.count))").foregroundColor(.blue).font(.headline).onTapGesture {
            expanded = !expanded
        }
    }
}

struct TestCaseView: View {

    let test: TestCase

    var body: some View {
        VStack {
            SVGView(fileURL: test.svgURL).padding()
            Image.of(pngURL: test.pngURL)
                .resizable()
                .aspectRatio(contentMode: .fit).padding()
        }
        .navigationTitle(test.name)
    }

}
