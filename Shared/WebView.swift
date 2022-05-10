//
//  WebView.swift
//  SVGViewTests
//
//  Created by Yuriy Strot on 03.02.2021.
//

import Foundation
import SwiftUI
import WebKit

#if os(iOS)
public struct WebView: View, UIViewRepresentable {

    public let svgUrl: URL
    public let webView = WKWebView()

    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        webView
    }

    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        webView.loadFileURL(svgUrl, allowingReadAccessTo: svgUrl.deletingLastPathComponent())
    }
}
#endif

#if os(macOS)

public struct WebView: View, NSViewRepresentable {

    public let svgUrl: URL
    public let webView = WKWebView()

    public func makeNSView(context: NSViewRepresentableContext<WebView>) -> WKWebView {
        return webView
    }

    public func updateNSView(_ uiView: WKWebView, context: NSViewRepresentableContext<WebView>) {
        webView.loadFileURL(svgUrl, allowingReadAccessTo: svgUrl.deletingLastPathComponent())
    }
}
#endif
