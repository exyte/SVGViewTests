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
        Text("\(suit.name) (\(suit.passed)/\(suit.items.count))")
            .foregroundColor(.blue)
            .font(.headline)
            .onTapGesture { expanded = !expanded }
    }
}

#if os(iOS)
enum CompareViewType: Int {
    case web
    case macaw
    case image
}
#endif

struct TestCaseView: View {

    let test: TestCase

    @State var location: CGPoint?

    var body: some View {
        content
            .background(Color.white)
            .navigationTitle(test.name)
    }

#if os(OSX)
    var content: some View {
        HStack {
            VStack {
                svgView
                webView
            }
            VStack {
                macaw
                image
            }
        }
    }
#else

    @State var compareViewType: CompareViewType = .web

    var content: some View {
        GeometryReader { geometry in
            if geometry.size.height >= geometry.size.width {
                VStack {
                    svgView
                    compareView
                }
            } else {
                HStack {
                    svgView
                    compareView
                }
            }
        }
    }

    var compareView: some View {
        ZStack {
            switch compareViewType {
            case .web:
                webView
            case .macaw:
                macaw
            case .image:
                image
            }
        }
        .onTapGesture(count: 2) {
            switch compareViewType {
            case .web:
                compareViewType = .macaw
            case .macaw:
                compareViewType = .image
            case .image:
                compareViewType = .web
            }
        }
    }
#endif

    var svgView: some View {
        SVGView(fileURL: test.svgURL)
            .modifier(Viewer(title: "SVGView", location: $location))
    }

    var webView: some View {
        WebView(svgUrl: test.svgURL)
            .modifier(Viewer(title: "WebKit", location: $location))
    }

    var macaw: some View {
        MacawSVGView(fileURL: test.svgURL)
            .modifier(Viewer(title: "Macaw", location: $location))
    }

    var image: some View {
        Image.from(url: test.pngURL)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(Viewer(title: "Image", location: $location))
    }

}

private struct Viewer: ViewModifier {
    let title: String
    @Binding var location: CGPoint?
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            Text(title).font(.title)
            ZStack {
                content
                Rectangle()
                    .fill(Color.white.opacity(0.001))
                if let location = location {
                    marker(pos: location)
                }
            }
            .gesture(DragGesture().onChanged { value in
                self.location = CGPoint(x: value.location.x, y: value.location.y)
            })
        }
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
