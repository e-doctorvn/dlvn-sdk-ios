//
//  IncomingVideoCallLayout.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 17/08/2023.
//

import SwiftUI

@available(iOS 14.3, *)
struct IncomingVideoCallLayout: View {
    
    @EnvironmentObject var directCallManager : DirectCallManager
    
    @State private var isMicMuted = true
    @State private var isCameraOff = true
    
    @State private var isAnimating = false
    
    @State private var alearNoPermission = false
    
    @State private var secondsRemaining = 59
    
    @ObservedObject var doctorInfomation = DoctorInfomation.shared
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundImage(UrlString: doctorInfomation.doctor.avatar == "" ? directCallManager.directCall?.caller?.profileURL : doctorInfomation.doctor.avatar, blur: 5)
                     .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                     .background((Color(red: 0.16, green: 0.16, blue: 0.16).opacity(1)))
                
                
                VStack {
                    Spacer()
                    HStack {
                        ZStack {
                            ForEach(0..<3) { index in
                                Circle()
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(Color.white)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 10)
                                            .scaleEffect(isAnimating ? 1.5 : 1.0)
                                            .opacity(isAnimating ? 0 : 1)
                                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false).delay(Double(index) * 0.5))
                                    )
                            }
                            .onAppear() {
                                isAnimating.toggle()
                            }
                            
                            AvatarView(UrlString: doctorInfomation.doctor.avatar == "" ? directCallManager.directCall?.caller?.profileURL : doctorInfomation.doctor.avatar, size: 60)
                                .equatable()
                                
                        }
                        
                        VStack {
                            HStack {
                                Text((doctorInfomation.doctor.fullName == "" ? "BS.\(directCallManager.directCall?.caller?.nickname ?? "")" : doctorInfomation.doctor.fullName)!)
                                    .font(
                                    Font.custom("Inter", size: 24)
                                    .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    
                                Spacer()
                            }
                            HStack {
                                Text("Đang gọi...")
                                    .font(Font.custom("Inter", size: 18))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                Spacer()
                            }

                        }.padding(.leading, 16)
                        
                    }
                    
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack {
                        HStack{
                            Spacer()
                            VStack {
                                Button(action: {
                                    DispatchQueue.main.async {
                                        APIService.shared.startRequest(graphQLQuery: eClinicExpireRinging, variables: DirectCallManager.shared.directCall?.customItems) { data, error in }
                                        directCallManager.endCallFast()
                                    }
                                }) {
                                    Image(systemName: "phone.down.fill")
                                        .font(.system(size: 30))
                                        .frame(width: 74, height: 74)
                                        .foregroundColor(Color.white)
                                        .background(Color(red: 0.96, green: 0.13, blue: 0.18))
                                        .clipShape(Circle())
                                    }
                                Text("Từ chối").font(
                                    Font.custom("Inter", size: 14)
                                    .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 16)
                            }
                            
                            
                            Spacer()
                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    if checkCameraAndMicrophonePermissions() {
                                        DispatchQueue.main.async {
                                            directCallManager.acceptCall(isMicOn: isMicMuted, isCamOn: isCameraOff)
                                            APIService.shared.startRequest(graphQLQuery: eClinicApproveCall, variables: DirectCallManager.shared.directCall?.customItems) { data, error in
                                                guard error == nil else {return}
                                                handleCountDown(reponseData: data ?? "")
                                            }
                                        }
                                    } else {
                                        alearNoPermission = true
                                    }

                                }) {
                                    Image(systemName: "phone.fill")
                                        .font(.system(size: 30))
                                        .frame(width: 74, height: 74)
                                        .foregroundColor(Color.white)
                                        .background(Color(red: 0.02, green: 0.56, blue: 0))
                                        .clipShape(Circle())
                                }
                                Text("Đồng ý")
                                .font(
                                Font.custom("Inter", size: 14)
                                .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.top, 16)
                            }

                            Spacer()
                        }

                        HStack{
                            Spacer()
                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    isMicMuted.toggle()
                                }) {
                                    Image(systemName: isMicMuted ? "mic.fill" : "mic.slash" )
                                        .frame(width: 50, height: 50)
                                        .font(.system(size: 22))
                                        .foregroundColor(Color.white)
                                        .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                        .clipShape(Circle())
                                }
                                Text("Mic")
                                    .padding(.top, 16)
                                .font(
                                Font.custom("Inter", size: 14)
                                .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            }

                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    isCameraOff.toggle()
                                }) {
                                    Image(systemName: isCameraOff ? "video.fill" : "video.slash" )
                                        .font(.system(size: 20))
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color.white)
                                        .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                        .clipShape(Circle())
                                }
                                Text("Camera")
                                    .padding(.top, 16)
                                .font(
                                Font.custom("Inter", size: 14)
                                .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            }

                            Spacer()
                            Spacer()

                            
                        }.frame(width: .infinity)
                        .padding(.top, 24)

                    }
                    Spacer()
                    
                }.padding(.horizontal, 32)
                    .alert(isPresented: $alearNoPermission) {
                           Alert(title: Text("Thông báo"),
                                 message: Text("Cần có quyền camera và microphone để thực hiện cuộc gọi"),
                                 dismissButton: .default(Text("Settings"), action: {
                               directCallManager.endCallFast()
                               let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                               if UIApplication.shared.canOpenURL(settingsURL) {
                                          UIApplication.shared.open(settingsURL)
                               }
                                         })
                           )
                       }

                
            }
        }
        .onAppear {
            DoctorInfomation.shared.getDoctor(variables: directCallManager.directCall?.customItems ?? [:])
            requestPermissions()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

//struct IncomingVideoCallLayout_Previews: PreviewProvider {
//    static var previews: some View {
//        IncomingVideoCallLayout()
//    }
//}
