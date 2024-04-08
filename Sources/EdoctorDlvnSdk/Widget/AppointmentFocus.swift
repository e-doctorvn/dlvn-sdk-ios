//
//  AppointmentFocus.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 08/04/2024.
//
import Foundation

@available(iOS 14.3, *)
public class AppointmentFocus : ObservableObject {
    
    static let shared = AppointmentFocus()
    
    @Published var appointment: AppointmentItemFocus = AppointmentItemFocus(eClinicId: "", appointmentScheduleId: "")
    
    public func setAppoinment(value : AppointmentItemFocus) {
        appointment = value
    }
    
}

public struct AppointmentItemFocus {
    let eClinicId: String
    let appointmentScheduleId: String
}

