//
//  Function.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 11/12/2023.
//
import Foundation

func checkEnableSdkBooking(currentIOS: String)-> Bool {
    if currentIOS == targetVersionBooking {
        return true
    }
    return currentIOS.compare(targetVersionBooking, options: .numeric) == .orderedDescending
}

func decodeJSON<T: Decodable>(data: Data, type: T.Type) throws -> T {
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(type, from: data)
        return decodedData
    } catch {
        throw error
    }
}
public func timeFormatted(secondsElapsed: TimeInterval) -> String {
    let hours = Int(secondsElapsed) / 3600
    let minutes = (Int(secondsElapsed) % 3600) / 60
    let seconds = Int(secondsElapsed) % 60
//    if hours == 0 {
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}


func convertDictionaryToString(dictionary: [AnyHashable: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        print("Error converting dictionary to string: \(error)")
    }
    return nil
}

@available(iOS 14.3, *)
func startCountDownDuration(callDuration: TimeInterval) {
    print("callDuration", callDuration)
    DispatchQueue.main.async {
        CountDownManager.shared.startCountDown(remainingTime: callDuration/1000)
    }

}

func handleCountDown(reponseData: String) {
    if let jsonData = reponseData.data(using: .utf8) {
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let data = json["data"] as? [String: Any],
               let eClinicApprove = data["eClinicApprove"] as? [String: Any],
               let callDuration = eClinicApprove["callDuration"] as? TimeInterval,
               let product = eClinicApprove["product"] as? [String: Any],
               let packages = product["packages"] as? [Any],
               let packagesItem = packages[0] as? [String: Any],
               let time = packagesItem["time"] as? TimeInterval {
                let totaltime = time*60000
                let result = totaltime - callDuration
                if #available(iOS 14.3, *) {
                    startCountDownDuration(callDuration: result > 0 ? result : 300)
                } else {
                    // Fallback on earlier versions
                }
            }

        } catch {
            print("Error: \(error)")
        }
    }
}
