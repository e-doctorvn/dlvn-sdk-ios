import SwiftUI
import WebKit
import AVKit


@available(iOS 14.3, *)
struct VideoCallScreen: View {
    
    @EnvironmentObject var directCallManager : DirectCallManager
    @EnvironmentObject var callStatusManager : CallStatusManager
//    var onClose: (() -> Void)
    @State private var isLocalAudioEnabled = true
    @State private var isLocalVideoEnabled = true
    @State private var isCallActive = true
    
    @State private var showToast = false
    @State private var changeMic = true
    
    
    @State private var isFrontCam = true
    
    @ObservedObject var counDownManager = CountDownManager.shared
    @ObservedObject var doctorInfomation = DoctorInfomation.shared
    @State private var isPiPMode = false
    var body: some View {

            GeometryReader { geometry in
                ZStack {
                    
                    BackgroundImage(UrlString: doctorInfomation.doctor.avatar == "" ? directCallManager.directCall?.caller?.profileURL : doctorInfomation.doctor.avatar, blur: 5)
                         .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    
                    

                    if (callStatusManager.callStatus == CallStatus.calling || callStatusManager.callStatus == CallStatus.videoCalling ) &&  directCallManager.directCall?.isRemoteVideoEnabled == true {
                        SendBirdVideoViewWrapper(sendBirdVideoView: (directCallManager.remoteVideoView))
//                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .frame(minWidth:geometry.size.width, maxWidth:geometry.size.width, minHeight:geometry.size.width/2, maxHeight:geometry.size.height)
                            .scaledToFit()
                        
                    }
                    
                    if (callStatusManager.callStatus == CallStatus.waiting) {
                        Text("Xin vui lòng chờ giây lát. Hệ thống đang kết nối đến Bác sĩ \(directCallManager.directCall?.caller?.nickname ?? "")")
                        .font(
                          Font.custom("Inter", size: 16)
                            .weight(.semibold)
                        )
                        .padding(.horizontal, 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width, alignment: .center)
                    }
                    
                    if (callStatusManager.callStatus == CallStatus.reconnect) {
                        Text("Gặp sự cố kết nối. Đang kết nối lại...")
                        .font(
                          Font.custom("Inter", size: 16)
                            .weight(.semibold)
                        )
                        .padding(.horizontal, 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width, alignment: .center)
                    }

                    Button(action: {
                        CallStatusManager.shared.setCallStatus(value: .videoCallWithChat)
                    }) {
                        Image(systemName: "chevron.backward")
                            .frame(width: 20, height: 20)
                            .font(.system(size: 22))
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    .position(x: 32, y: 65)
                    
                    
                    if (callStatusManager.callStatus == .calling || callStatusManager.callStatus == .videoCalling || callStatusManager.callStatus == .reconnect) {
                        VStack {
                            HStack {
                                Spacer()
                                ZStack {
                                    SendBirdVideoViewWrapper(sendBirdVideoView: (directCallManager.localVideoView))
                                    Button(action: {
                                        isFrontCam.toggle()
                                    }) {
                                        Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                            .font(Font.custom("Font Awesome 6 Pro", size: 22))
                                            .foregroundColor(Color(red: 0.16, green: 0.16, blue: 0.16))
                                            .frame(width: 27.42857, height: 23.12507)
                                            .opacity(0.6)
                                    }
                                    .padding(.top, 110)
                                    .onChange(of: isFrontCam) { newValue in
                                        directCallManager.directCall?.switchCamera() { error in
                                            
                                        }
                                    }
                                }.frame(width: 100, height: 150).background(Color.gray)
                                    .cornerRadius(8)

                            }.padding(.trailing, 16)
                            Spacer()
                        }.padding(.top, 45)
                    }
                    
                    VStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 16) {
                            VStack {
                                
                                HStack(alignment: .center, spacing: 4) {
                                    Rectangle()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(Color(red: 0.87, green: 0.09, blue: 0.12))
                                        .clipShape(Circle())
                                    Text("\(timeFormatted(secondsElapsed: counDownManager.remainingTime))")
                                      .font(Font.custom("Inter", size: 11))
                                      .foregroundColor(.white)
                                      .onChange(of: counDownManager.remainingTime) { newValue in
//                                          if newValue == 0 {
//                                              directCallManager.endCall()
//                                          }
                                      }
                                }
                                .padding(.horizontal, 8)
                                .frame(width: .infinity, height: 20, alignment: .center)
                                .background(Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.4))
                                .cornerRadius(100)

                                .padding(.bottom, 16)
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        CallStatusManager.shared.setCallStatus(value: .videoCallWithChat)
                                    }) {
                                        VStack {
                                            Image("chatImage")
                                                .frame(width: 50, height: 50)
                                                .font(.system(size: 22))
                                                .foregroundColor(Color.white)
                                                .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                                .clipShape(Circle())
                                            Text("Chat")
                                                .padding(.top, 12)
                                                .font(
                                                    Font.custom("Inter", size: 14)
                                                        .weight(.medium)
                                                )
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                            
                                        }
                                    }
                                    .onChange(of: isLocalAudioEnabled) { newValue in
                                        if newValue {
                                            directCallManager.directCall?.unmuteMicrophone()
                                        } else {
                                            directCallManager.directCall?.muteMicrophone()
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        isLocalAudioEnabled.toggle()
                                    }) {
                                        VStack {
                                            Image(systemName: isLocalAudioEnabled ?  "mic.fill" : "mic.slash")
                                                .frame(width: 50, height: 50)
                                                .font(.system(size: 22))
                                                .foregroundColor(Color.white)
                                                .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                                .clipShape(Circle())
                                            Text("Mic")
                                                .padding(.top, 12)
                                                .font(
                                                    Font.custom("Inter", size: 14)
                                                        .weight(.medium)
                                                )
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                            
                                        }
                                    }
                                    .onChange(of: isLocalAudioEnabled) { newValue in
                                        changeMic = true
                                        showToast = true
                                        if newValue {
                                            directCallManager.directCall?.unmuteMicrophone()
                                        } else {
                                            directCallManager.directCall?.muteMicrophone()
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        isLocalVideoEnabled.toggle()
                                    }) {
                                        VStack {
                                            Image(systemName: isLocalVideoEnabled ? "video.fill" : "video.slash" )
                                                .font(.system(size: 20))
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(Color.white)
                                                .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                                .clipShape(Circle())
                                            
                                            Text("Camera")
                                                .padding(.top, 12)
                                                .font(
                                                    Font.custom("Inter", size: 14)
                                                        .weight(.medium)
                                                )
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .onChange(of: isLocalVideoEnabled) { newValue in
                                        changeMic = false
                                        showToast = true
                                        
                                        if newValue {
                                            directCallManager.directCall?.startVideo()
                                        } else {
                                            directCallManager.directCall?.stopVideo()
                                        }
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        APIService.shared.startRequest(graphQLQuery: eClinicEndCall, variables: DirectCallManager.shared.directCall?.customItems) { data, error in }
                                        directCallManager.endCall()
                                    }) {
                                        VStack {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 20))
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(Color.white)
                                                .background(Color(red: 0.92, green: 0.33, blue: 0.27))
                                                .clipShape(Circle())
                                            
                                            Text("Kết thúc")
                                                .padding(.top, 12)
                                            .font(
                                            Font.custom("Inter", size: 14)
                                            .weight(.medium)
                                            )
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                        }

                                    }
                                  
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                        .frame(width: .infinity, alignment: .top)
                        .background(Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.4))
                    }
                    
                    
                    if (counDownManager.remainingTime > 294 && counDownManager.remainingTime <= 300) {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                VStack {
                                    Text("Sắp hết phiên tư vấn")
                                        .foregroundColor(.white)
                                }
                                .frame(width: geometry.size.width*0.8)
                                .padding(16)
                                .background(Color(red: 0.9, green: 0.4, blue: 0.4))
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 2, y: 4)
                                
                                
                            }.padding(.bottom, 180)
                            Spacer()
                        }.opacity(0.8)
                    }
                    
                    if (showToast) {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                VStack {
                                    if (changeMic) {
                                        Text("bạn đã \(isLocalAudioEnabled == true ? "bật": "tắt") microphone")
                                            .foregroundColor(.white)
                                    } else {
                                        Text("bạn đã \(isLocalVideoEnabled == true ? "bật": "tắt") camera")
                                            .foregroundColor(.white)
                                    }

                                }
                                .frame(width: geometry.size.width*0.8)
                                .padding(16)
                                .background((Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.4)))
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 2, y: 4)
                                
                                
                            }.padding(.bottom, 180)
                            Spacer()
                        }.opacity(0.85)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    if (showToast) {
                                        self.showToast = false
                                    }
                                }
                            }
                    }
                    

                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.gray)
                .onAppear {
                    isLocalAudioEnabled = directCallManager.directCall?.isLocalAudioEnabled ?? true
                    isLocalVideoEnabled = directCallManager.directCall?.isLocalVideoEnabled ?? true
                    requestPermissions()
                    
                    
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            }
   

    }
}

//struct VideoCallScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoCallScreen()
//    }
//}

