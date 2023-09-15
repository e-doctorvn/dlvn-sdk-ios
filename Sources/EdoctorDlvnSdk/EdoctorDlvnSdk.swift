import SwiftUI
import UIKit
import WebKit
import SafariServices


public func openWebView(currentViewController: UIViewController? = nil, withURL urlString: String) {
    // Tạo một SwiftUI View chứa WebView và nút "Close"
    if #available(iOS 13.0, *) {
        let fullScreenWebView = FullScreenWebView(urlString: urlString)
        // Tạo một UIHostingController chứa fullScreenWebView
        let hostingController = UIHostingController(rootView: fullScreenWebView)
        hostingController.modalPresentationStyle = .fullScreen
        // Hiển thị UIHostingController fullscreen
        if currentViewController != nil {
            currentViewController!.present(hostingController, animated: true, completion: nil)
        } else if let currentViewController2 = UIApplication.shared.windows.first?.rootViewController {
            currentViewController2.present(hostingController, animated: true, completion: nil)
        }
    } else {
        let webview = WebViewController(brandColor: UIColor(red: 239/255, green: 23/255, blue: 23/255, alpha: 1), textColor: .white)
        webview.modalPresentationStyle = .fullScreen
        
        currentViewController!.present(webview, animated: true)
    }
}


public func openWebView(currentViewController: UIViewController? = nil) {
    // Tạo một SwiftUI View chứa WebView và nút "Close"
    if #available(iOS 13.0, *) {
        let fullScreenWebView = FullScreenWebView(urlString: "https://e-doctor.dev/tu-van-suc-khoe")
        // Tạo một UIHostingController chứa fullScreenWebView
        let hostingController = UIHostingController(rootView: fullScreenWebView)
        hostingController.modalPresentationStyle = .fullScreen
        // Hiển thị UIHostingController fullscreen
        if currentViewController != nil {
            currentViewController!.present(hostingController, animated: true, completion: nil)
        } else if let currentViewController2 = UIApplication.shared.windows.first?.rootViewController {
            currentViewController2.present(hostingController, animated: true, completion: nil)
        }
    } else {
        let webview = WebViewController(brandColor: UIColor(red: 239/255, green: 23/255, blue: 23/255, alpha: 1), textColor: .white)
        webview.modalPresentationStyle = .fullScreen
        
        currentViewController!.present(webview, animated: true)
    }
}

public func openWebViewTest(currentViewController: UIViewController) {
    let webview = WebViewController(brandColor: .white, textColor: .gray)
    webview.modalPresentationStyle = .fullScreen
    
    currentViewController.present(webview, animated: true)
}

public func openWebviewSafari(currentViewController: UIViewController) {
    let safariViewController = SFSafariViewController(url: URL(string: "https://e-doctor.dev/tu-van-suc-khoe")!)
    safariViewController.preferredBarTintColor = .white
    safariViewController.preferredControlTintColor = .gray
                safariViewController.dismissButtonStyle = .close
                safariViewController.modalPresentationStyle = .fullScreen
                currentViewController.present(safariViewController, animated: true)

}

public func sampleFunc(data: String, completion: @escaping (Result<String, Error>) -> Void) {
    completion(.success("data của bạn gửi là \(data)"))
}

public func sampleFunc(data: String) -> String{
     return "data của bạn gửi là \(data)"
}

private func openAlert(from viewController: UIViewController) {
    let alertController = UIAlertController(title: "Thông báo", message: "Vui Lòng upgrade OS để xử dụng chức năng này!", preferredStyle: .alert)

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







