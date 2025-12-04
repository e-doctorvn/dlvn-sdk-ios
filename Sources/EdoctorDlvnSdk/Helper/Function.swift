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

func formatDateString(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let date = dateFormatter.date(from: dateString) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: Date())
        let todayDate = calendar.date(from: components)!
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "'Hôm nay,' HH:mm"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        }
        
        return dateFormatter.string(from: date)
    } else {
        return "Invalid date format"
    }
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


func startCountDownDuration(callDuration: TimeInterval) {
    DispatchQueue.main.async {
        CountDownManager.shared.startCountDown(remainingTime: callDuration/1000)
    }

}


func handleCountDown(reponseData: String) {
    if let jsonData = reponseData.data(using: .utf8) {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let value = try decoder.decode(CountDown.self, from: jsonData)
            let callDuration = value.data?.eClinicApprove.callDuration ?? 0
            let time = value.data?.eClinicApprove.product?.packages?[0].time ?? 0
            let totaltime = time*60000
            let result = totaltime - callDuration
            startCountDownDuration(callDuration: result > 0 ? result : 300)

        } catch {
            startCountDownDuration(callDuration: 30*60000)
            print("Error decoding JSON: \(error)")
        }
    } else {
        startCountDownDuration(callDuration: 30*60000)
    }
}

struct CountDown: Codable  {
    let data: CountDown1?
}

struct CountDown1: Codable  {
    let eClinicApprove: EClinicApprove
}


struct EClinicApprove: Codable, Hashable  {
    let callDuration: TimeInterval?
    let product: Product?
}

public struct Product: Codable, Hashable {
    let packages: [PackagesItem]?
    
}

public struct PackagesItem: Codable, Hashable {
    let time: TimeInterval?
}

