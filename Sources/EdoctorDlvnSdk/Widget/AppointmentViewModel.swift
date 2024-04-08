//
//  AppointmentViewModel.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 03/04/2024.
//

import Apollo
import Foundation

@available(iOS 14.3, *)
class AppointmentViewModel: ObservableObject {
    
    static let shared = AppointmentViewModel()
    
    @Published var appointmentList: [AppointmentSchedules] = []
    
    init() {
        getData()
    }
    
    
    func getData() {
        print("manhne getdata")
        let currentUserStore: UserInfo? = LocalStore.getData(key: .userInfoKey)
    //    if currentUserStore?.userId == nil {
    //        return
    //    }
        
        let limit: [String: Any] = [
            "start": 0,
            "limit": 50
        ]
        let variables : [String: Any] = [
            "accountId": "dev_tyncTuiOKl5kPJly",
            "variables": limit,
            "state": ["PENDING", "JOINING", "RINGING", "EXPIRED_RINGING", "ENDCALL"]
        ]
        APIService.shared.startRequest(graphQLQuery: getAppointmentSchedule, variables: variables, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyVHlwZSI6ImNvbnN1bWVyIiwic291cmNlVHlwZSI6IkRMVk4iLCJhY2NvdW50SWQiOiJkZXZfdHluY1R1aU9LbDVrUEpseSIsInVzZXJJZCI6IjY1NDg2ZGUyYzllMTY4MDAxMzgxZDlmZSIsImRjSWQiOiIwNTVGRDAzQy03NTI4LTRFRkYtQjI5Qi0wMTJGMDU0QkUzRDEiLCJkZXZpY2VpZCI6ImMyNjY2ZGU2OWU5ZDRlNzA5NmYyNTQ0NTM0ZmE4OTk4IiwiZGNBY2Nlc3NUb2tlbiI6IjAzY2Y3NjE4YmQ1YzQwM2Q4MjQ4NTIzMDg5NmI4OThiIiwiaWF0IjoxNzExOTYwNDE1fQ._l3X82W3bbcZgcnpKL_FTBZyYcczEG9_rMBvmnAIcr8") { data, error in
     
            if error != nil || data == nil {
                return
            }
            

            
            if let jsonData = data!.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let list = try decoder.decode(AppointmentSchedulesResponse.self, from: jsonData)
                    print("manhne", list.data?.appointmentSchedules.count)
                    

                    
                    DispatchQueue.main.async {
                        self.appointmentList = list.data?.appointmentSchedules ?? []
                    }
                    
           
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            
        }
        return
    }
  
}




struct AppointmentSchedulesResponse: Codable  {
    let data: AppointmentSchedulesResponse1?
}

struct AppointmentSchedulesResponse1: Codable  {
    let appointmentSchedules: [AppointmentSchedules]
}


struct AppointmentSchedules: Codable, Hashable  {
    let appointmentScheduleId: String?
    let doctor: DoctorAppointment?
    let profile: Profile?
    let package: String?
    let scheduledAt: String?
    let state: String?
    let eClinic: EClinic
    let thirdParty: ThirdParty
}

public struct DoctorAppointment: Codable, Hashable {
    let avatar: String?
    let fullName: String?
    let degree: Degree?
    
}

public struct ThirdParty: Codable, Hashable {
    let sendbird: Sendbird?
}

public struct Sendbird: Codable, Hashable {
    let channelUrl: String?
}

public struct Degree: Codable, Hashable {
    let shortName: String?
}

public struct Profile: Codable, Hashable {
    let profileId: String?
    let fullName: String?
}

public struct EClinic: Codable, Hashable {
    let eClinicId: String?
}
