//
//  WitgetItem.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 03/04/2024.
//

import SwiftUI

@available(iOS 14.3, *)
struct WitgetItem: View {
    
    var item: AppointmentSchedules
    var currentViewController: UIViewController? = nil
    var data: [String: Any]? = nil
    @Binding var isPresented: Bool

    @State private var isButtonActionLoading = false
    @State private var isErrorConfirmTimeValidation = false
//    var status = "PENDING"
//    var type = "VIDEO"
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 10) {
                //=======1======
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 8){
                        AvatarView(UrlString: "\((env == .SANDBOX ?  "https://e-doctor.dev" : "https://edoctor.io") + "/_upload/image/" + (item.doctor?.avatar ?? ""))", size: 90)
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {

                                Text("Lịch \(item.package == "VIDEO" ? "video" : "nhắn tin"):")
                                  .font(
                                    Font.custom("Inter", size: 14)
                                      .weight(.medium)
                                  )
                                  .foregroundColor(Color(red: 0.16, green: 0.16, blue: 0.16))
                                getStatus(status: (item.state ?? "PENDING"), type: item.package)
                            }

                            Text("\(formatDateString(item.scheduledAt ?? "2024-04-08T02:35:00.000Z"))")
                              .font(
                                Font.custom("Inter", size: 12)
                                  .weight(.medium)
                              )
                              .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                            HStack(spacing: 0) {
                                Text("\(item.doctor?.degree?.shortName ?? "")")
                                  .font(Font.custom("Inter", size: 14))
                                  .foregroundColor(Color(red: 0.16, green: 0.16, blue: 0.16))
                                
                                Text(" \(item.doctor?.fullName ?? "---")")
                                  .font(
                                    Font.custom("Inter", size: 14)
                                      .weight(.semibold)
                                  )
                                  .foregroundColor(Color(red: 0.16, green: 0.16, blue: 0.16))
                            }
                            HStack(spacing: 0) {
                                // Inter/12/Medium
                                Text("Tư vấn cho: ")
                                  .font(
                                    Font.custom("Inter", size: 12)
                                      .weight(.medium)
                                  )
                                  .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                                
                                // Inter/12/Medium
                                Text(" \(item.profile?.fullName ?? "---")")
                                  .font(
                                    Font.custom("Inter", size: 12)
                                      .weight(.medium)
                                  )
                                  .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                            }
                        }
                        .padding(8)
                        .frame(height: 92, alignment: .topLeading)
                        
                    }
                    
                    HStack {
                        //1
                        if  item.state == "PENDING" ||  item.state == "JOINING" ||  item.state == "EXPIRED_RINGING" {
                            Button(action: {
                                print("okok")
                                self.isPresented = true
                                AppointmentFocus.shared.setAppoinment(value: AppointmentItemFocus(eClinicId: item.eClinic.eClinicId ?? "", appointmentScheduleId: item.appointmentScheduleId ?? ""))
                            }) {
                                // Inter/13/SemiBold
                                Text("Hủy lịch hẹn")
                                  .font(
                                    Font.custom("Inter", size: 13)
                                      .weight(.semibold)
                                  )
                                  .foregroundColor(Color(red: 0.87, green: 0.09, blue: 0.12))
                            }
                                .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32, alignment: .center)
                                .background(Color.white)

                                .cornerRadius(6)
                                .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.87, green: 0.09, blue: 0.12), lineWidth: 1)

                                )

                        }

                        ///2
                        
                        Button(action: {
                            onPressAction(status: item.state, type: item.package)
                        }) {
                            HStack {
                                if isButtonActionLoading {
                                    ProgressView().padding(.trailing, 5)
                                }
                                
                                Text("\(getTextbyStatusandType(status: item.state, type: item.package))")
                                  .font(
                                    Font.custom("Inter", size: 13)
                                      .weight(.semibold)
                                  )
                                  .foregroundColor(Color.white)
                            }


                        }
                        .disabled(isButtonActionLoading)
                        .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32, alignment: .center)
                        .background(
                        LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0.92, green: 0.4, blue: 0.27), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.82, green: 0.16, blue: 0.12), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1.01, y: 1)
                        )
                        )
                        .cornerRadius(6)
                    }.frame(width: geometry.size.width - 32)
                }.padding(16)
                    .frame(alignment: .leading)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))

                    .cornerRadius(8)
                    .overlay(
                    RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 1)
                    )

            
            }
            .alert(isPresented: $isErrorConfirmTimeValidation) {
                Alert(title: Text("Thông báo"), message: Text("Chưa đến khung giờ tư vấn. Vui lòng chờ thử lại sau"), dismissButton: .default(Text("Đã hiểu")))
            }

        }



    }
    
    func getTextbyStatusandType(status: String?, type: String?) -> String{
        switch status {
        case "PENDING":
            return "Tư vấn ngay"
        case "JOINING":
            return "Nhắn tin"
        case "EXPIRED_RINGING":
            return "Xác nhận chờ gọi lại"
        case "RINGING":
            return "Nhận cuộc gọi"
        case "JOINED":
            return type == "VIDEO" ? "Vào phòng tư vấn" : "Nhắn tin"
        case "ENDCALL":
            return "Nhắn tin"
        default:
            return "Nhắn tin"
        }
        }
    
    func getStatus(status: String, type: String?) -> some View {
        switch status {
        case "PENDING":
            return AnyView(JoiningView(text: "Đã đặt lịch", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        case "JOINING":
            return AnyView(JoiningView(text: "Chờ \(type == "Video" ? "gọi" : "")tư vấn", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        case "EXPIRED_RINGING":
            return AnyView(JoiningView(text: "Bị nhỡ", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        case "RINGING":
            return AnyView(JoiningView(text: "Bác sĩ đang gọi", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        case "JOINED":
            return AnyView(JoiningView(text: "Đang tư vấn", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        case "ENDCALL":
            return AnyView(JoiningView(text: "Đang tư vấn", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        default:
            return AnyView(JoiningView(text: "Đã đặt lịch", color: Color(red: 0.51, green: 0.78, blue: 0.46), textColor: Color.white))
        }
        }
    
    func onPressAction(status: String?, type: String?) -> Void {
        let variables : [String: Any] = [
            "eClinicId": item.eClinic.eClinicId ?? "",
            "appointmentScheduleId": item.appointmentScheduleId ?? "",
        ]
        switch status {
        case "PENDING":
            isButtonActionLoading = true
            print("pendding")
            APIService.shared.startRequest(graphQLQuery: AppointmentScheduleConfirm, variables: variables, isPublic: false) { dataCall, error in
                if error != nil {
                    isErrorConfirmTimeValidation = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isButtonActionLoading = false
                    }
                }

            }
        case "JOINING", "JOINED", "ENDCALL":
            let url = getUrlDefault() + "/phong-tu-van?channel=" + (item.thirdParty.sendbird?.channelUrl ?? "")
            openWebView(currentViewController: currentViewController, withURL: url, data: data)
        case "EXPIRED_RINGING":
            print("EXPIRED_RINGING")
            isButtonActionLoading = true
            APIService.shared.startRequest(graphQLQuery: EClinicReissue, variables: variables, isPublic: false) { dataCall, error in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isButtonActionLoading = false
                }
            }
        case "RINGING":
            print("RINGING")
            if DirectCallManager.shared.directCall != nil {
                DispatchQueue.main.async {
                    inCommingCall(currentViewController: currentViewController, call: DirectCallManager.shared.directCall!, isPushNoti: false)
                }
            }

        default:
            print("default")
        }
    }
    
    
}


    
@available(iOS 14.3, *)
struct JoiningView: View {
        var text: String = ""
        var color: Color = Color(red: 0.51, green: 0.78, blue: 0.46)
        var textColor: Color = Color(red: 0.51, green: 0.78, blue: 0.46)
        var body: some View {
            HStack(alignment: .center, spacing: 50) {
                Text("\(text)")
                  .font(
                    Font.custom("Inter", size: 14)
                      .weight(.semibold)
                  )
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(textColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(100)
        }
    }
//
//#Preview {
//    WitgetItem()
//}
