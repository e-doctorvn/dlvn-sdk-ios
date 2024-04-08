//
//  AppointmentController.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 03/04/2024.
//

import Foundation

@available(iOS 14.3, *)
public class AppointmentController : ObservableObject {
    
    static let shared = AppointmentController()
    
    @Published var appointmentSchedule: [AppointmentModel?] = []
    
    public func setAppointmentSchedule(value : [AppointmentModel?]) {
        DispatchQueue.main.async {
            self.appointmentSchedule = value
        }

    }
    
}

public struct AppointmentModel: Codable, Hashable {
    let avatar: String?
    let package: String?
    let state: String?
    let scheduledAt: String?
    let doctorShortName: String?
    let doctorFullName: String?
    let profileFullName: String?
}

func getData(accountId: String)-> [AppointmentModel] {
    let limit: [String: Any] = [
        "start": 0,
        "limit": 3
    ]
    let variables : [String: Any] = [
        "accountId": accountId,
        "variables": limit,
    ]
    APIService.shared.startRequest(graphQLQuery: getAppointmentSchedule, variables: variables) { data, error in
        
    }
    return []
}


