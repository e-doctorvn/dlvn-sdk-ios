//
//  DoctorInfomation.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 03/01/2024.
//

import Foundation

@available(iOS 14.3, *)
public class DoctorInfomation : ObservableObject {
    
    static let shared = DoctorInfomation()
    
    @Published var doctor: Doctor = Doctor(avatar: "", fullName: "", channelUrl: "")
    
    public func setInfomation(newDoctor: Doctor) {
        doctor =  Doctor(avatar: ((env == .SANDBOX ?  "https://e-doctor.dev" : "https://edoctor.io") + "/_upload/image/" + newDoctor.avatar), fullName: newDoctor.fullName, channelUrl: newDoctor.channelUrl)
    }
    
    public func reset() {
        doctor = Doctor(avatar: "", fullName: "", channelUrl: "")
    }
    
    public func getDoctor(variables: [String: Any]) {
        APIService.shared.startRequest(graphQLQuery: AppointmentDetail, variables: variables, isPublic: true) { data, error in
            if error != nil || data == nil {
                return
            }
            
            if let jsonData = data!.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let data = json["data"] as? [String: Any],
                       let appointmentSchedules = data["appointmentSchedules"] as? [Any],
                       let appointmentSchedulesItem = appointmentSchedules[0] as? [String: Any],
                       let doctor = appointmentSchedulesItem["doctor"] as? [String: Any],
                       let avatar = doctor["avatar"] as? String,
                       let fullName = doctor["fullName"] as? String,
                       let degree = doctor["degree"] as? [String: Any],
                       let shortName = degree["shortName"] as? String,
                       let thirdParty = appointmentSchedulesItem["thirdParty"] as? [String: Any],
                       let sendbird = thirdParty["sendbird"] as? [String: Any],
                       let channelUrl = sendbird["channelUrl"] as? String{
                        DoctorInfomation.shared.setInfomation(newDoctor: Doctor(avatar: avatar, fullName: (shortName + fullName), channelUrl: channelUrl))
                       }

                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
}

public struct Doctor: Codable {
    let avatar: String
    let fullName: String?
    let channelUrl: String?
}
