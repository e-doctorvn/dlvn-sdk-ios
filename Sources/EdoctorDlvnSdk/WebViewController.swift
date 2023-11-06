import UIKit
import SwiftUI
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: MyWebView!
    var urlString: String = urlDefault
    var data: [String: Any]? = nil
    var onClose: (() -> Void)?
    
    var onSdkRequestLogin: ((String) -> Void)?
    
    private var activityIndicator: UIActivityIndicatorView!
    
    
    var loaded: Bool = false
    
    init(urlString: String, onClose: (() -> Void)?, data: [String: Any]? = nil, onSdkRequestLogin: ((String) -> Void)? = nil) {
        self.urlString = urlString
        self.data = data
        super.init(nibName: nil, bundle: nil)
        self.onClose = onClose
        self.onSdkRequestLogin = onSdkRequestLogin
        self.loaded = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        _setUpWebView()
        _setUpUI()
        
        ControlerAlert.shared.setViewController(value: self)
        
        let myRequest = URLRequest(url: URL(string:urlString)!)
        
        webView.load(myRequest)
        
    }
    
    private func _setUpWebView(){
        webView = MyWebView(onSdkRequestLogin: onSdkRequestLogin)
        webView.uiDelegate = self
  
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.bounces = false
  
        webView.navigationDelegate = self
        

    }
    
    private func _setUpUI(){
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        
        view.addSubview(navigationBar)
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        
        let window = UIApplication.shared.windows.last
        let topPadding = window?.safeAreaInsets.top
        
        
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: view.safeAreaInsets.top + topPadding!).isActive = true
        
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }

    
    let navigationBar: UIView = {
        let view = UIView()
        let window = UIApplication.shared.windows.last
        let topPadding = window?.safeAreaInsets.top
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0)
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.812, green: 0.322, blue: 0.251, alpha: 1).cgColor,
            UIColor(red: 0.886, green: 0.38, blue: 0.255, alpha: 1).cgColor,
        ]
        layer0.locations = [0, 1]

        layer0.startPoint = CGPoint(x: 0.5, y: 1)
        layer0.endPoint = CGPoint(x: 0.5, y: 0)

        layer0.bounds = view.bounds
        layer0.position = view.center
        
        view.layer.addSublayer(layer0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()

    }

    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if (!loaded && (data != nil)) {
            webView.stopLoading()
            DLVNSendData(data: data!) { status, error in
                print(status)
                DispatchQueue.main.async { [self] in
                    if status {
                        let dlvnToken = DLVNAccessToken.getData()
                            webView.evaluateJavaScript("document.cookie=\"accessToken=\(dlvnToken?.accessToken ?? ""); path=/\"")
                            webView.evaluateJavaScript("document.cookie=\"upload_token=\(dlvnToken?.accessToken ?? ""); path=/\"")
                        webView.evaluateJavaScript("document.cookie=\"accessTokenDlvn=\(data!["token"] ?? ""); path=/\"")

                        self.loaded = true
                        webView.reload()

                    } else {
                        self.activityIndicator.stopAnimating()
                        self.alertErrorWebView(from: self, content: error?.localizedDescription)
                    }
                }
            }
        }
        
    }
    
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

//    }


    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        self.activityIndicator.stopAnimating()
//        self.alertErrorWebView(from: self, content: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
        self.alertErrorWebView(from: self, content: error.localizedDescription)
    }
    
    private func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    
    // WKNavigationDelegate method - Được gọi khi cần quyết định việc tải một URL
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if #available(iOS 14.3, *) {
//            decisionHandler(.allow)
//        } else {
//            if let url = navigationAction.request.url {
//                if url.absoluteString == "https://khuat.dai-ichi-life.com.vn:8082/login" {
//
//                    decisionHandler(.cancel)
//                    activityIndicator.stopAnimating()
//                    openAlert(from: self, content: nil)
//                    return
//                }
//            }
//
//            decisionHandler(.allow)
//        }
//
//    }
    
    public func alertErrorWebView(from viewController: UIViewController, content: String?) {
        let alertController = UIAlertController(title: "Thông báo", message: "\(content ?? "Đã có lỗi xãy ra!")", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Trở về", style: .default) { (action) in
           self.dismiss(animated: true)
        }
        
        let okReload = UIAlertAction(title: "Thử lại", style: .default) { (action) in
            self.activityIndicator.startAnimating()
            let myRequest = URLRequest(url: URL(string:self.urlString)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            
            self.webView.load(myRequest)
        }
        alertController.addAction(okAction)
        alertController.addAction(okReload)

        viewController.present(alertController, animated: true, completion: nil)
    }
    
}




