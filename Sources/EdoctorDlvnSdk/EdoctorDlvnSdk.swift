import SwiftUI
import UIKit
import WebKit



public func openWebView(currentViewController: UIViewController? = nil, withURL urlString: String? = urlDefault,data: [String: Any]? = nil, onSdkRequestLogin: ((String) -> Void)? = nil) {
    
    let webview = WebViewController(urlString: urlString ?? urlDefault, onClose: nil, data: data, onSdkRequestLogin: onSdkRequestLogin)
    
    webview.modalPresentationStyle = .fullScreen

    if (currentViewController != nil) {
        currentViewController!.present(webview, animated: true)
    } else if let currentViewController = UIApplication.shared.windows.first?.rootViewController {
        currentViewController.present(webview, animated: true)
    }
}


public func deleteAccessToken() {
    DLVNAccessToken.deleteData()
}

public func clearWebViewCache() {
    deleteAccessToken()
    deleteCache()
}

private func deleteCache() {
    let websiteDataStore = WKWebsiteDataStore.default()

    let dataTypes = Set([WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage])

    let date = Date(timeIntervalSince1970: 0)
    websiteDataStore.removeData(ofTypes: dataTypes, modifiedSince: date) {
        print("Cache đã được xóa.")
    }

}

public func DLVNSendData(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
    
    do {
        let decoder = JSONDecoder()
        let jsonDataInput = try JSONSerialization.data(withJSONObject: data, options: [])
        let dataInput = try decoder.decode(DLVNInputData.self, from: jsonDataInput)
        
        let edoctorData = EdoctorData(deviceid: dataInput.deviceid, partnerid: dataInput.partnerid, dcid: dataInput.dcId, token: dataInput.token)
        let jsonData = try JSONEncoder().encode(edoctorData)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let edoctorInputData = EdoctorInputData(signature: "", dcId: dataInput.dcId, data: jsonString)
            getData(dataInput: edoctorInputData) { dataOutput, error in
                if let error = error {
                    print("Lỗi: \(error)")
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }

    } catch {
        completion(false, error)
    }
    
}


func getData(dataInput: EdoctorInputData, completion: @escaping (EdoctorOutputResult?, Error?) -> Void) {

    let apiUrlString = "\(urlApiDefault)graphql"
    
    guard let apiUrl = URL(string: apiUrlString) else {
        print("URL không hợp lệ")
        return
    }
    
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"

    
    let graphQLQuery = """
    mutation DLVNAccountInit($data: String, $signature: String, $dcId: String) { dlvnAccountInit(data: $data, signature: $signature, dcId: $dcId) { phone accessToken }}
    """
    
    let variables: [String: Any] = [
        "signature": dataInput.signature,
        "dcId": dataInput.dcId,
        "data": dataInput.data
    ]
    
    
    let graphQLRequest: [String: Any] = ["query": graphQLQuery, "variables": variables]
    
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: graphQLRequest) {
        request.httpBody = jsonData
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("Bearer YourAccessToken", forHTTPHeaderField: "Authorization")

    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(nil, error)
        } else if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                print("Phản hồi từ server: \(responseString)")
            }
            do {

                let decoder = JSONDecoder()
                let dataOutput = try decoder.decode(EdoctorOutputDataServer.self, from: data)
                
                if dataOutput.data.dlvnAccountInit == nil {
                    completion(nil, NSError(domain: "Edoctor", code: 800, userInfo: ["message": "Data trả về null"]))
                } else {
                    let result = EdoctorOutputResult(phone: dataOutput.data.dlvnAccountInit?.phone, accessToken: dataOutput.data.dlvnAccountInit?.accessToken)
                    DLVNAccessToken.saveData(edoctorOutputResult: result)
                    completion(result, nil)
                }

            } catch {
                print("Lỗi phân tích dữ liệu JSON: \(error)")
            }
        }
    }
    
    task.resume()
}

public func openAlert(from viewController: UIViewController, content: String?) {
    let alertController = UIAlertController(title: "Thông báo", message: "\(content ?? "Vui Lòng upgrade OS 13++ để xử dụng chức năng này!")", preferredStyle: .alert)

    let okAction = UIAlertAction(title: "Đồng ý", style: .default) { (action) in
        
    }
    alertController.addAction(okAction)

    viewController.present(alertController, animated: true, completion: nil)
}

public func changeEnv(envUpdate: Env) {
    env = envUpdate
}


@objc public class DlvnSdk: NSObject {
    @objc public func openWebViewOC(currentViewController: UIViewController? = nil, withURL urlString: String? = urlDefault, data: [String: Any]? = nil) {
        openWebView(currentViewController: currentViewController, withURL: urlString, data: data)
    }
    
    @objc public func openWebViewOC(currentViewController: UIViewController? = nil, withURL urlString: String? = urlDefault, data: [String: Any]? = nil, onSdkRequestLogin: @escaping ((String) -> Void)) {
        openWebView(currentViewController: currentViewController, withURL: urlString, data: data, onSdkRequestLogin: onSdkRequestLogin)
    }
    
    @objc public func DLVNSendDataOC(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        DLVNSendData(data: data) { dataOutput, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    @objc public func clearWebViewCacheOC() {
        clearWebViewCache()
    }
    
    @objc public func changeLiveEnv() {
        env = Env.LIVE
    }
    
    @objc public func changeDevEnv() {
        env = Env.SANDBOX
    }
    
}







