//
//  MyScriptMessageHandler.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 12/09/2023.
//

import WebKit

class MyScriptMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "myMessageHandler" {
            if let data = message.body as? String {
                print("Dữ liệu từ webview: \(data)")
            }
        }
    }
}

class MyWebView: WKWebView {

    init() {
        
        let scriptMessageHandler = MyScriptMessageHandler()
        let userContentController = WKUserContentController()
        userContentController.add(scriptMessageHandler, name: "myMessageHandler")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        
        super.init(frame: CGRect.zero, configuration: configuration)
        
//        super.evaluateJavaScript("javascript:window.webkit.messageHandlers.myMessageHandler.postMessage(`okok`)")
        super.evaluateJavaScript("javascript:(window.ios = `{\"oke\": \"data ios\"}`)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

