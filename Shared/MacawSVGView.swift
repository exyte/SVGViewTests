//
//  MacawSVGView.swift
//  SVGViewTests
//
//  Created by Yuriy Strot on 03.02.2021.
//

import Foundation
import SwiftUI
import Macaw

struct MacawContainer {

    let svgView = MacawView()
    let fileURL: URL

    func makeUIView() -> MacawView {
        svgView.contentMode = .scaleToFill
        return svgView
    }

    func updateUIView() {
        if let text = try? String(contentsOf: fileURL) {
            if let node = try? SVGParser.parse(text: text) {
                svgView.node = node
            }
        }
    }

}

#if os(iOS)
struct MacawSVGView: UIViewRepresentable {

    let container: MacawContainer

    init(fileURL: URL) {
        container = MacawContainer(fileURL: fileURL)
    }

    func makeUIView(context: Context) -> UIView {
        return container.makeUIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        container.updateUIView()
    }
}
#endif

#if os(macOS)
struct MacawSVGView: View, NSViewRepresentable {

    let container: MacawContainer

    init(fileURL: URL) {
        container = MacawContainer(fileURL: fileURL)
    }

    func makeNSView(context: Context) -> NSView {
        return container.makeUIView()
    }

    func updateNSView(_ uiView: NSView, context: Context) {
        container.updateUIView()
    }
}
#endif
