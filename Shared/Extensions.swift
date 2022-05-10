//
//  Extensions.swift
//  SVGViewTests
//
//  Created by Yuriy Strot on 24.01.2021.
//

import Foundation
import SwiftUI

#if os(OSX)

import AppKit

extension View {
    func updateNavigationBarTitle(_ title: String) -> some View {
        return self.navigationTitle(title)
    }
}

extension Image {

    static func from(url: URL) -> Image {
        if let img = NSImage(contentsOf: url) {
            return Image(nsImage: img)
        }
        return Image(systemName: "xmark.octagon")
    }
}

#else

import UIKit

extension View {
    func updateNavigationBarTitle(_ title: String) -> some View {
        return self.navigationBarTitle(title, displayMode: .inline)
    }
}

extension Image {
    static func from(url: URL) -> Image {
        if let data = try? Data(contentsOf: url) {
            if let img = UIImage(data: data) {
                return Image(uiImage: img)
            }
        }
        return Image(systemName: "xmark.octagon")
    }
}

#endif
