//
//  WitgetList.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 03/04/2024.
//

import SwiftUI

@available(iOS 14.3, *)
struct WidgetList: View {
    
    var currentViewController: UIViewController? = nil
    var data: [String: Any]? = nil
    
    @ObservedObject var list = AppointmentViewModel.shared
    @State private var isPresented = false
    @State private var isAppointmentCancelSuccess = false
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top) {
                    ForEach(list.appointmentList, id: \.self) { item in
                        WitgetItem(item: item, currentViewController: currentViewController, data: data, isPresented: $isPresented).frame(width: geometry.size.width - 40)
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        VStack(alignment: .center, spacing: 14) {
                            
                            HStack(spacing: 8) {
                                Text("Lối tắt vào phòng tư vấn")
                                  .font(
                                    Font.custom("Inter", size: 16)
                                      .weight(.semibold)
                                  )
                                  .foregroundColor(Color(red: 0.6, green: 0.35, blue: 0))
                            }
                        }
                    }
                    .padding(.leading, 60.5)
                    .padding(.trailing, 59.5)
                    .frame(width:343, height: list.appointmentList.count > 0 ? 172 : 0, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                    RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 1)

                    )
                }
            }.padding(8)
                .alert(isPresented: $isPresented) {
                    if (isAppointmentCancelSuccess) {
                        Alert(title: Text("Thông báo"), message: Text("Hủy lịch hẹn thành công"), dismissButton: .default(Text("Đã hiểu"), action: {
                            isAppointmentCancelSuccess = false
                        }))
                    } else {
                        Alert(title: Text("Xác nhận"), message: Text("Bạn có muốn hủy lịch hẹn?"), primaryButton: .destructive(Text("Hủy lịch hẹn"), action: {
                            let variables : [String: Any] = [
                                "eClinicId": AppointmentFocus.shared.appointment.eClinicId,
                                "appointmentScheduleId": AppointmentFocus.shared.appointment.appointmentScheduleId,
                            ]
                            APIService.shared.startRequest(graphQLQuery: AppointmentScheduleCancel, variables: variables, isPublic: false, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyVHlwZSI6ImNvbnN1bWVyIiwic291cmNlVHlwZSI6IkRMVk4iLCJhY2NvdW50SWQiOiJkZXZfdHluY1R1aU9LbDVrUEpseSIsInVzZXJJZCI6IjY1NDg2ZGUyYzllMTY4MDAxMzgxZDlmZSIsImRjSWQiOiIwNTVGRDAzQy03NTI4LTRFRkYtQjI5Qi0wMTJGMDU0QkUzRDEiLCJkZXZpY2VpZCI6ImMyNjY2ZGU2OWU5ZDRlNzA5NmYyNTQ0NTM0ZmE4OTk4IiwiZGNBY2Nlc3NUb2tlbiI6IjAzY2Y3NjE4YmQ1YzQwM2Q4MjQ4NTIzMDg5NmI4OThiIiwiaWF0IjoxNzExOTYwNDE1fQ._l3X82W3bbcZgcnpKL_FTBZyYcczEG9_rMBvmnAIcr8") { dataCall, error in
                                if error == nil {

                                    isAppointmentCancelSuccess = true
                                    isPresented = true
                                }
                            }
                        }), secondaryButton: .cancel(Text("Đóng")))
                    }

                }
        }.frame(height: list.appointmentList.count > 0 ? 300 : 0)
    }
}

//#Preview {
//    WitgetList()
//}
