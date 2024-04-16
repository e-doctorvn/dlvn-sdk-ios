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
                    if list.appointmentList.count > 0 {
                        HStack(alignment: .center, spacing: 0) {
                            
                            VStack(alignment: .center, spacing: 8) {
                                
                                Image("room", bundle: Bundle(for: WebViewController.self))
                                    .frame(width: 92, height: 92)
                                
                                HStack(spacing: 8) {
                                    Image("enterRoom", bundle: Bundle(for: WebViewController.self))
                                        .frame(width: 50, height: 50)
                                        .font(.system(size: 22))
                        
                                    Text("Lối tắt vào phòng tư vấn")
                                      .font(
                                        Font.custom("Inter", size: 16)
                                          .weight(.semibold)
                                      )
                                      .foregroundColor(Color(red: 0.6, green: 0.35, blue: 0))
                                }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        .frame(width:geometry.size.width - 32, height: 172, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 1)

                        )
                    }
                    
                }
            }.padding(8)
                .alert(isPresented: $isPresented) {
                    if isAppointmentCancelSuccess {
                        return Alert(title: Text("Thông báo"), message: Text("Hủy lịch hẹn thành công"), dismissButton: .default(Text("Đã hiểu"), action: {
                            isAppointmentCancelSuccess = false
                        }))
                    } else {
                        return Alert(title: Text("Xác nhận"), message: Text("Bạn có muốn hủy lịch hẹn?"), primaryButton: .destructive(Text("Hủy lịch hẹn"), action: {
                            let variables : [String: Any] = [
                                "eClinicId": AppointmentFocus.shared.appointment.eClinicId,
                                "appointmentScheduleId": AppointmentFocus.shared.appointment.appointmentScheduleId,
                            ]
                            APIService.shared.startRequest(graphQLQuery: AppointmentScheduleCancel, variables: variables, isPublic: false) { dataCall, error in
                                if error == nil {
                                    isAppointmentCancelSuccess = true
                                    isPresented = true
                                    
                                    handleWidgetGetdata()
                                }
                            }
                        }), secondaryButton: .cancel(Text("Đóng")))
                    }

                }
        }
        .onAppear {
            handleWidgetGetdata()
        }
        .frame(height: list.appointmentList.count > 0 ? 300 : 0)
    }
}

//#Preview {
//    WitgetList()
//}
