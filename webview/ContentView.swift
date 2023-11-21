//
//  ContentView.swift
//  webview
//
//  Created by Dominic Damoah on 11/21/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var showingWebView = false
    private var urlString: String {
        return loadProperty(key: "DEBUG_INDEX_PAGE")
    }

    var body: some View {
        VStack(spacing: 20){
            if let url = URL(string: urlString) {
                WebView(url: url)
            } else {
                Text("Invalid URL")
            }
        }
    }

    private func loadProperty(key: String) -> String {
        guard let propertiesURL = Bundle.main.url(forResource: "local", withExtension: "properties"),
              let propertiesContent = try? String(contentsOf: propertiesURL) else {
            return "https://purdue.edu" // Default URL in case the file can't be read
        }

        let properties = propertiesContent.components(separatedBy: "\n")
        for property in properties {
            let keyValue = property.components(separatedBy: "=")
            if keyValue.count == 2 && keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines) == key {
                return keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return "https://purdue.edu" // Default URL in case the key isn't found
    }
}

struct WebView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
