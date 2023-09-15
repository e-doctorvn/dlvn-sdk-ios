import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var brandColor: UIColor
    var textColor: UIColor
    
    init(brandColor: UIColor, textColor: UIColor) {
        self.brandColor = brandColor
        self.textColor = textColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = brandColor
        navigationBar.backgroundColor = brandColor
        closeButton.tintColor = textColor
        reloadButton.tintColor = textColor
        
        _setUpWebView()
        _setUpUI()
        
        let myRequest = URLRequest(url: URL(string:"https://e-doctor.dev/tu-van-suc-khoe")!)
        webView.load(myRequest)
    }
    
    private func _setUpWebView(){
        let userController: WKUserContentController = WKUserContentController()
        userController.addUserScript(getZoomDisableScript())
        let config = WKWebViewConfiguration()
        config.userContentController = userController
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.bounces = false
    }
    
    private func _setUpUI(){
        view.addSubview(navigationBar)
        view.addSubview(webView)
        navigationBar.addSubview(closeButton)
        navigationBar.addSubview(reloadButton)
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16).isActive = true
        closeButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 12).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive=true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive=true
        closeButton.addTarget(self, action: #selector(onPressClose), for: .touchUpInside)
        

        reloadButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16).isActive = true
        reloadButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 12).isActive = true
        reloadButton.heightAnchor.constraint(equalToConstant: 24).isActive=true
        reloadButton.widthAnchor.constraint(equalToConstant: 24).isActive=true
        reloadButton.addTarget(self, action: #selector(onPressReload), for: .touchUpInside)
    }
    
    @objc func onPressClose(){
        self.dismiss(animated: true)
    }
    
    @objc func onPressReload(){
        webView.reload()
    }
    
    @objc func onPressBack(){
        webView.goBack()
    }
    @objc func onPressForward(){
        webView.goForward()
    }
    
    let navigationBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let closeIcon = UIImage(named: "backImage")
        button.setImage(closeIcon, for: .normal)
        return button
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(named: "backImage")
        
        button.setImage(icon, for: .normal)
        return button
    }()
    
   
    func onCloseWebView() {

    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    @available(iOS 15.0, *)
    func webView(
            _ webView: WKWebView,
            requestMediaCapturePermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            type: WKMediaCaptureType,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
        ) {
            decisionHandler(.grant)
        }
}

@available(iOS 13.0, *)
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //TODO
    }
    
}
@available(iOS 13.0, *)
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error 01")
        let wkError = (error as NSError)
        if (wkError.code == NSURLErrorNotConnectedToInternet) {
            
        } else {
            
        }
        onCloseWebView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let wkError = (error as NSError)
        print("NAVIGATE ERR:", wkError)
    }
}
