import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    public var webView: MyWebView!
    var urlString: String
    var data: [String: Any]? = nil
    var onClose: (() -> Void)?
    var isFromNotification: Bool
    var encodedData: String?
    
    var onSdkRequestLogin: ((String) -> Void)?
    
    private var activityIndicator: UIActivityIndicatorView!
    
    
    var loaded: Bool = false
    
    init(urlString: String?, onClose: (() -> Void)?, data: [String: Any]? = nil, onSdkRequestLogin: ((String) -> Void)? = nil, isFromNotification: Bool = false, encodedData: String? = nil) {
        self.urlString = urlString ?? getUrlDefault()
        self.data = data
        self.isFromNotification = isFromNotification
        super.init(nibName: nil, bundle: nil)
        self.onClose = onClose
        self.onSdkRequestLogin = onSdkRequestLogin
        self.loaded = false
        self.encodedData = encodedData
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoadUrl), name: .handleLoadUrl, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleLoadUrl(_ notification: Notification) {
        if let url = notification.userInfo?["url"] as? String{
            let myRequest = URLRequest(url: URL(string:url)!)
            if (webView != nil && url != "") {
                webView.load(myRequest)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func onGoback() {
        webView.goBack()
    }
    
    public func onCloseWebview() {
        if webView.canGoBack {
            // web handle
        } else {
            if onClose != nil {
                onClose!()
            } else {
                self.dismiss(animated: true)
                ControlerAlert.shared.reSetViewController()
                rollBackChatAndCall()
            }

        }
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
        webView = MyWebView(onSdkRequestLogin: onSdkRequestLogin, onGoBack: onGoback, onCloseWebview: onCloseWebview, handleLoginAndAgree: handleLoginAndAgree)
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
        navigationBar.heightAnchor.constraint(equalToConstant: view.safeAreaInsets.top + (topPadding ?? 0)).isActive = true
        
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//
//        DispatchQueue.main.async {
//            let window = UIApplication.shared.windows.last
//            let topPadding = window?.safeAreaInsets.top
//            self._setUpUI()
//        }
//
//    }


    
    let navigationBar: UIView = {
        let view = UIView()
        let window = UIApplication.shared.windows.last
        let topPadding = window?.safeAreaInsets.top
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0)
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.824, green: 0.333, blue: 0.251, alpha: 1).cgColor,
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [self] in
            activityIndicator.stopAnimating()
        }
//        webView.allowsBackForwardNavigationGestures = false

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
         if navigationAction.navigationType == WKNavigationType.linkActivated {
             if let url = navigationAction.request.url {
                 if (url.host!.contains("dai-ichi-life.com.vn") || url.absoluteString.contains("/tu-van-suc-khoe")) {
                     if #available(iOS 14.3, *) {
                         webView.load( URLRequest(url: URL(string:(url.absoluteString + "?from=eDoctor&screen=eDoctorHome"))!))
                     } else {
                         if (url.absoluteString.contains("tu-van-suc-khoe/phong-tu-van") || url.absoluteString.contains("tu-van-suc-khoe/tu-van-tu-xa")) {
                                 decisionHandler(.cancel)
                                 openAlert(from: self, content: "Chức năng này yêu cầu iOS tối thiểu 14.3, Phiên bản hiện tại của bạn là \(UIDevice.current.systemVersion), Vui lòng nâng cấp hệ điều hành để có thể sử dụng được chức năng này")
                                 return
                         } else {
                             webView.load( URLRequest(url: URL(string:(url.absoluteString + "?from=eDoctor&screen=eDoctorHome"))!))
                         }
                     }

                 } else {
                     UIApplication.shared.open(url)
                     decisionHandler(.cancel)
                     return
                 }
             }
         }
         decisionHandler(.allow)
    }

    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let value = checkEnableSdkBooking(currentIOS: UIDevice.current.systemVersion)
        
        // use to checking allow boking consultant in web if iOS > 14.3
        webView.evaluateJavaScript("sessionStorage.setItem('disableSdkBooking', '\(!value)');");
        
        // use to checking support consultant in web
        webView.evaluateJavaScript("sessionStorage.setItem('sdkSupportConsultant', \(true));");
        
        
        if (onClose != nil || isFromNotification) {
            let dataTemp: DataLogin? = LocalStore.getData(key: .dataLogin)
            if dataTemp != nil && dataTemp?.deviceid != nil  {
                data = [
                    "partnerid": dataTemp?.partnerid as Any,
                    "deviceid": dataTemp?.deviceid as Any,
                    "dcId": dataTemp?.dcId as Any,
                    "token": dataTemp?.token as Any
                ]
            }
        }
        
        if (!loaded && (data != nil)) {
            webView.stopLoading()
            
            APIService.shared.startRequest(graphQLQuery: checkAccountExist, variables: ["phone" : data!["dcId"] as Any], isPublic: true) { dataCall, error in
                
                if let jsonData = dataCall!.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let reponseData = json["data"] as? [String: Any],
                           let checkAccountExist = reponseData["checkAccountExist"] as? Bool {
                            print("??okok")
                            if checkAccountExist {
                                print("okok1")
                                self.handleLogin()
                            } else {
                                print("okok")
                                webView.evaluateJavaScript("sessionStorage.setItem('consent', '\(true)');");
                                self.loaded = true
                                webView.reload()
                            }
                        }

                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
    
    func handleLoginAndAgree() {
        handleLogin(callAgree: true)
    }
    
    func handleLogin(callAgree: Bool? = false) {
        DLVNSendData(data: self.data!) { status, error in
            DispatchQueue.main.async { [self] in
                if status {

                    let dlvnToken: EdoctorOutputResult? = LocalStore.getData(key: storeType.EdoctorDLVNAccessTokenKey)
                    
//                        webView.evaluateJavaScript("document.cookie=\"accessToken=\(dlvnToken?.accessToken ?? ""); path=/\"")
//                        webView.evaluateJavaScript("document.cookie=\"upload_token=\(dlvnToken?.accessToken ?? ""); path=/\"")
//                        webView.evaluateJavaScript("document.cookie=\"accessTokenDlvn=\(data!["token"] ?? ""); path=/\"")
                    
                    webView.evaluateJavaScript("sessionStorage.setItem('accessTokenEdr', '\(dlvnToken?.accessToken ?? "")');");
                    webView.evaluateJavaScript("sessionStorage.setItem('upload_token', '\(dlvnToken?.accessToken ?? "")');");
                    webView.evaluateJavaScript("sessionStorage.setItem('accessTokenDlvn', '\(data!["token"] ?? "")');");

                    self.loaded = true
                    webView.reload()
                    
                    // save
                    let dataSave = DataLogin(partnerid: data!["partnerid"] as! String, deviceid: data!["deviceid"] as! String, dcId: data!["dcId"] as! String, token: data!["token"] as! String)
                    
                    LocalStore.saveData(dataSave: dataSave, key: .dataLogin)
                    
                    if callAgree == true {
                        let variables : [String: Any] = [
                            "isAcceptAgreement": true,
                            "isAcceptShareInfo": true,
                        ]
                        print("dong y")
                        APIService.shared.startRequest(graphQLQuery: AccountUpdateAggrement, variables: variables, isPublic: false) { dataCall, error in
                        }
                    }

                } else {
                    self.activityIndicator.stopAnimating()
                    self.alertErrorWebView(from: self, content: error?.localizedDescription)
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
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if let url = navigationAction.request.url {
//                print("okok", url)
//            }
//        decisionHandler(.allow)
//    }
    
    public func alertErrorWebView(from viewController: UIViewController, content: String?) {
        var text = "Đã có lỗi xãy ra. Vui lòng thử lại"
        if content == "The Internet connection appears to be offline." {
            text = "Không có kết nối internet. Vui lòng kiểm tra lại."
        }
        let alertController = UIAlertController(title: "Thông báo", message: "\(text)", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Trở về", style: .default) { (action) in
           self.dismiss(animated: true)
            ControlerAlert.shared.reSetViewController()
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


extension Notification.Name {
    static let handleLoadUrl = Notification.Name("handleLoadUrl")
}



