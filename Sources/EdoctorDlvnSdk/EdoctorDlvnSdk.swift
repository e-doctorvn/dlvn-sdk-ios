import SwiftUI
import UIKit
import WebKit



public func openWebView(currentViewController: UIViewController? = nil, withURL urlString: String) {
    let webview = WebViewController(urlString: urlString, onClose: nil)
    webview.modalPresentationStyle = .fullScreen

    if (currentViewController != nil) {
        currentViewController!.present(webview, animated: true)
    } else if let currentViewController = UIApplication.shared.windows.first?.rootViewController {
        currentViewController.present(webview, animated: true)
    }
}


public func openWebView(currentViewController: UIViewController? = nil) {
    let webview = WebViewController(urlString: urlDefault, onClose: nil)
    webview.modalPresentationStyle = .fullScreen

    if (currentViewController != nil) {
        currentViewController!.present(webview, animated: true)
    } else if let currentViewController = UIApplication.shared.windows.first?.rootViewController {
        currentViewController.present(webview, animated: true)
    }
}

public func sampleFunc(data: String, completion: @escaping (Result<String, Error>) -> Void) {
    completion(.success("data của bạn gửi là \(data)"))
}

public func sampleFunc(data: String) -> String{
     return "data của bạn gửi là \(data)"
}

public func openAlert(from viewController: UIViewController, content: String?) {
    let alertController = UIAlertController(title: "Thông báo", message: "\(content ?? "Vui Lòng upgrade OS 13++ để xử dụng chức năng này!")", preferredStyle: .alert)

    let okAction = UIAlertAction(title: "Đồng ý", style: .default) { (action) in
        
    }
    alertController.addAction(okAction)

    viewController.present(alertController, animated: true, completion: nil)
}


@objc public class DlvnSdk: NSObject {
    @objc public func openWebViewOC(currentViewController: UIViewController? = nil) {
        openWebView(currentViewController: currentViewController)
    }
    
    @objc public func openWebViewOC() {
        openWebView()
    }
    
    @objc public func sampleFuncOC(data: String) -> String{
         return "data của bạn gửi là \(data)"
    }
    
}







