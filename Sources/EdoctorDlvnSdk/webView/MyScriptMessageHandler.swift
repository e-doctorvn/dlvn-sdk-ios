//
//  MyScriptMessageHandler.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 12/09/2023.
//

import WebKit

class MyScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    var onSdkRequestLogin: ((String) -> Void)?
    var onGoBack: (() -> Void)?
    var onCloseWebview: (() -> Void)?
    
    init(onSdkRequestLogin: ((String) -> Void)?, onGoBack: (() -> Void)?, onCloseWebview: (() -> Void)?) {
        self.onSdkRequestLogin = onSdkRequestLogin
        self.onGoBack = onGoBack
        self.onCloseWebview = onCloseWebview
    }
    
    func noHandle(data : String) {
        
    }
    
    func noHandle() {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "myMessageHandler" {
            if let data = message.body as? String {
                do {
                    let dataReceiveType = try JSONDecoder().decode(DataReceiveType.self, from: data.data(using: .utf8)!)
                    
                    switch dataReceiveType.type {

                    case closeWebView:
                        (onCloseWebview ?? noHandle)()
                        
                        if channel_url_active != "entry_channel_url" {
                            channel_url_active = "entry_channel_url"
                        }
  
                    case requestLoginNative:
                        (onSdkRequestLogin ?? noHandle)(dataReceiveType.data?.currentUrl ?? "")
                        ControlerAlert.shared.viewController?.dismiss(animated: true)
                    case activeChannelUrl:
                        channel_url_active = dataReceiveType.channelUrl ?? "entry_channel_url"
                    case requestUpdateApp:
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1435474783") {
                            UIApplication.shared.open(url)
                        }
                    default:
                        print("default")
                    }
                } catch {
                    print("error parse JSON: \(error)")
                }

            }
        }
        
        if message.name == "edoctorEventHandler" {
            if let data = message.body as? String {
                
                do {
                    let dataReceiveType = try JSONDecoder().decode(DataReceiveType.self, from: data.data(using: .utf8)!)
                    
                    switch dataReceiveType.type {

                    case goBack:
                        (onGoBack ?? noHandle)()
                        
                        if channel_url_active != "entry_channel_url" {
                            channel_url_active = "entry_channel_url"
                        }

                    case sharedArticle:
                        if ((dataReceiveType.url) != nil) {
                            let urlToShare = URL(string: dataReceiveType.url ?? "")!
                              let items = [urlToShare]
                              let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                            ControlerAlert.shared.viewController?.present(activityViewController, animated: true, completion: nil)
                        }
                    case activeChannelUrl:
                        channel_url_active = dataReceiveType.channelUrl ?? "entry_channel_url"
                    case requestUpdateApp:
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1435474783") {
                            UIApplication.shared.open(url)
                        }
                    default:
                        print("default")
                    }
                } catch {
                    print("error parse JSON: \(error)")
                }
            }
        }
    }
}

class MyWebView: WKWebView {

    init(onSdkRequestLogin: ((String) -> Void)?, onGoBack: (() -> Void)?, onCloseWebview: (() -> Void)?) {
        
        let scriptMessageHandler = MyScriptMessageHandler(onSdkRequestLogin: onSdkRequestLogin, onGoBack: onGoBack, onCloseWebview: onCloseWebview)
        let userContentController = WKUserContentController()
        userContentController.add(scriptMessageHandler, name: "myMessageHandler")
        userContentController.add(scriptMessageHandler, name: "edoctorEventHandler")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
//        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent() // no cache
        
        
        
        // disable zoom webview
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        
        
        
        super.init(frame: CGRect.zero, configuration: configuration)
        

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DataReceiveType: Codable {
    let type: String
    let data: URLData?
    let url: String?
    let channelUrl: String?
}
struct URLData: Codable{
    let currentUrl: String?
}



