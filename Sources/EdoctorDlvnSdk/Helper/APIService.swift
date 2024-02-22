//
//  APIService.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 30/11/2023.
//

import Foundation

enum HttpMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case OPTIONS = "OPTIONS"
    case HEAD = "HEAD"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    
}


class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func startRequest(graphQLQuery: String, variables: [String: Any]? = [:], httpMethod: HttpMethod? = HttpMethod.POST, isPublic : Bool = false, completion: @escaping (String?, Error?) -> Void) {
        print("==> start call api")
        let apiUrlString = "\(getApiDefault())graphql"
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("URL không hợp lệ")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = httpMethod?.rawValue
        
        let graphQLRequest: [String: Any] = ["query": graphQLQuery, "variables": variables as Any]
        
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: graphQLRequest) {
            request.httpBody = jsonData
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dlvnToken: EdoctorOutputResult? = LocalStore.getData(key: storeType.EdoctorDLVNAccessTokenKey)
        
        if dlvnToken?.accessToken == nil && isPublic != true{
            print("==> accessToken nil")
            completion(nil, NSError(domain: "Edoctor", code: 300, userInfo: ["message": "Không có token "]))
            return
        }
        
        
        if dlvnToken?.accessToken != nil{
            request.addValue(dlvnToken?.accessToken ?? "", forHTTPHeaderField: "Authorization")
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                print("==> lỗi: \(error)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("==> Phản hồi từ server: \(responseString)")
                    completion(responseString, nil)
                } else {
                    completion(nil, NSError(domain: "Edoctor", code: 802, userInfo: ["message": "Không lấy được data dang string"]))
                }
            }
        }
        
        task.resume()
    }
    
    
}

