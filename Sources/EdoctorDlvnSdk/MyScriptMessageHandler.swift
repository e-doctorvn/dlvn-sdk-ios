//
//  MyScriptMessageHandler.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 12/09/2023.
//

import WebKit

class MyScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    var onAuthenDataResult: ((AuthenData) -> Void)?
    
    init(onAuthenDataResult: ((AuthenData) -> Void)?) {
        self.onAuthenDataResult = onAuthenDataResult
    }
    
    func noHandle(data : AuthenData) {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "myMessageHandler" {
            if let data = message.body as? String {
                do {
                    let dataReceiveType = try JSONDecoder().decode(DataReceiveType.self, from: data.data(using: .utf8)!)
                    
                    switch dataReceiveType.type {

                    case closeWebView:
                        ControlerAlert.shared.viewController?.dismiss(animated: true)
  
                    case authenDataResult:
                        (onAuthenDataResult ?? noHandle)(dataReceiveType.data!)
                    default:
                        print("ok")
                    }
                } catch {
                    print("error parse JSON: \(error)")
                }

            }
        }
    }
}

class MyWebView: WKWebView {

    init(onAuthenDataResult: ((AuthenData) -> Void)?) {
        
        let scriptMessageHandler = MyScriptMessageHandler(onAuthenDataResult: onAuthenDataResult)
        let userContentController = WKUserContentController()
        userContentController.add(scriptMessageHandler, name: "myMessageHandler")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent() // no cache
        
        
        super.init(frame: CGRect.zero, configuration: configuration)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DataReceiveType: Codable {
    let type: String
    let data: AuthenData?
}

@objc public class AuthenData: NSObject, Codable {
    @objc public let edrToken: String?
    @objc public let dlvnToken: String?
    @objc public let dcid: String?
}



