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
                    Text("\(test.passed ? "✅" : "❌") \(test.name)")
                }
            }
        }
    }

    func getHeader() -> some View {
        Text("\(suit.name) (\(suit.passed)/\(suit.items.count))").foregroundColor(.blue).font(.headline).onTapGesture {
            expanded = !expanded
        }
    }
}

struct TestCaseView: View {

    let test: TestCase

    @State var location: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            let rect = geometry.frame(in: .global)
            let size = rect.size
            let svgAndImage = VStack(spacing: 0) {
                Text("SVGView").font(.title)
                SVGView(fileURL: test.svgURL).gesture(DragGesture().onChanged { value in
                    self.location = CGPoint(x: value.location.x, y: value.location.y)
                })
                Text("Image").font(.title)
                Image.of(pngURL: test.pngURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit).gesture(DragGesture().onChanged { value in
                        self.location = CGPoint(x: value.location.x, y: value.location.y)
                    })
            }
            ZStack {
            #if os(OSX)
                HStack(spacing: 0) {
                    svgAndImage
                    VStack(spacing: 0) {
                        Text("Macaw").font(.title)
                        MacawSVGView(fileURL: test.svgURL)
                        Text("WebKit").font(.title)
                        Rectangle().fill(Color.clear)
                    }
                }
            #else
                svgAndImage
            #endif
                if let p = location {
                    marker(pos: p)
                    marker(pos: CGPoint(x: p.x, y: p.y + size.height / 2))
                }
            }
        }
        .background(Color.white)
        .navigationTitle(test.name)
    }

    func marker(pos: CGPoint) -> some View {
        ZStack {
            line(x1: pos.x - 5, y1: pos.y - 4, x2: pos.x + 5, y2: pos.y + 6, color: .black)
            line(x1: pos.x - 5, y1: pos.y + 6, x2: pos.x + 5, y2: pos.y - 4, color: .black)
            line(x1: pos.x - 5, y1: pos.y - 5, x2: pos.x + 5, y2: pos.y + 5, color: .red)
            line(x1: pos.x - 5, y1: pos.y + 5, x2: pos.x + 5, y2: pos.y - 5, color: .red)
        }
    }

    func line(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, color: Color) -> some View {
        var path = Path()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        return path.stroke(color)
    }

}
