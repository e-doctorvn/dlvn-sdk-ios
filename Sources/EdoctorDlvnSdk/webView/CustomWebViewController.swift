import UIKit
import WebKit

class CustomWebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String
    var activityIndicator: UIActivityIndicatorView!

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)


        activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // MARK: WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        activityIndicator.stopAnimating()
    }
}
