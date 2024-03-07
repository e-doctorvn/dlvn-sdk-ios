//
//  VideoCallWithChatLayout.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 23/08/2023.
//

import SwiftUI

@available(iOS 14.3, *)
struct VideoCallWithChatLayout: View {

    @EnvironmentObject var directCallManager : DirectCallManager
    
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    @GestureState private var dragOffset: CGSize = .zero
    @State private var isScaled = true
    
    @ObservedObject var counDownManager = CountDownManager.shared
    
    @State private var isLocalAudioEnabled = true
    @State private var isLocalVideoEnabled = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                WebViewWrapper().equatable()
                ZStack {
                    ZStack {
                        BackgroundImage(UrlString: directCallManager.directCall?.caller?.profileURL, blur: 5)
                            .frame(width: 120, height: 180)
                        
                        

                        if directCallManager.directCall?.isRemoteVideoEnabled == true {
                            SendBirdVideoViewWrapper(sendBirdVideoView: (directCallManager.remoteVideoView))
                            .frame(width: 120, height: 180)
                        }
  
                        
                        VStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 16) {
                                VStack {
                                    
                                    HStack(alignment: .center, spacing: 2.5602) {
                                        Rectangle()
                                            .frame(width: 6, height: 6)
                                            .foregroundColor(Color(red: 0.87, green: 0.09, blue: 0.12))
                                            .clipShape(Circle())
                                        Text("\(timeFormatted(secondsElapsed: counDownManager.remainingTime))")
                                            .font(Font.custom("Inter", size: 7.6806))
                                            .foregroundColor(.white)
                                            .onChange(of: counDownManager.remainingTime) { newValue in
                                                if newValue == 0 {
                                                    directCallManager.endCall()
                                                }
                                            }
                                    }.padding(.horizontal, 4)
                                    .frame(width: .infinity, height: 12, alignment: .center)
                                    .background(Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.4))
                                    .cornerRadius(100)
                                    .padding(.top, 4)
                                    
                                    HStack {
                                        Button(action: {
                                            isLocalAudioEnabled.toggle()
                                        }) {
                                            VStack {
                                                Image(systemName: isLocalAudioEnabled ?  "mic.fill" : "mic.slash")
                                                    .frame(width: 25, height: 25)
                                                    .font(.system(size: 10))
                                                    .foregroundColor(Color.white)
                                                    .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                                    .clipShape(Circle())
                                                
                                            }
                                        }
                                        .onChange(of: isLocalAudioEnabled) { newValue in
                                            if newValue {
                                                directCallManager.directCall?.unmuteMicrophone()
                                            } else {
                                                directCallManager.directCall?.muteMicrophone()
                                            }
                                        }
                                        Button(action: {
                                            isLocalVideoEnabled.toggle()
                                        }) {
                                            VStack {
                                                Image(systemName: isLocalVideoEnabled ? "video.fill" : "video.slash" )
                                                    .font(.system(size: 10))
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(Color.white)
                                                    .background(Color(red: 0.78, green: 0.51, blue: 0.35))
                                                    .clipShape(Circle())
                                                
                                            }
                                        }
                                        .onChange(of: isLocalVideoEnabled) { newValue in
                                            if newValue {
                                                directCallManager.directCall?.startVideo()
                                            } else {
                                                directCallManager.directCall?.stopVideo()
                                            }
                                        }
                                        
                                        Button(action: {
                                            directCallManager.endCall()
                                        }) {
                                            VStack {
                                                Image(systemName: "xmark")
                                                    .font(.system(size: 10))
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(Color.white)
                                                    .background(Color(red: 0.92, green: 0.33, blue: 0.27))
                                                    .clipShape(Circle())
                                                
                                            }

                                        }
                                    
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.bottom, 7)
                            .frame(width: 118, alignment: .top)
                            .background(Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.4))
                        }


                    }
                    .frame(width: 120, height: 180)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: 1)
                        .stroke(.white, lineWidth: 2)
                    )
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 2, y: 4)

                    Button(action: {

                    }) {
                        Image(systemName: "arrow.down.backward.and.arrow.up.forward")
                            .frame(width: 20, height: 20)
                            .font(.system(size: 22))
                            .foregroundColor(Color.white)
                    }
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 1.20009, x: 0, y: 1.20009)
                    .position(x: 120, y: 5)
                }.frame(width: 120, height: 180)
                .scaleEffect(isScaled ? 4 : 1.0)
                .animation(.easeInOut)
                .position(location)
                .gesture(
                    simpleDrag
                )
                .gesture(
                    TapGesture()
                        .onEnded {
                            onClick()
                        }
                )
                
            }.onAppear {
                print("okok - Vao")
                location = CGPoint(x: geometry.size.width - 90, y: 250)
                isScaled = false
                
                isLocalAudioEnabled = directCallManager.directCall?.isLocalAudioEnabled ?? true
                isLocalVideoEnabled = directCallManager.directCall?.isLocalVideoEnabled ?? true
            }
            
        }.edgesIgnoringSafeArea(.bottom)
        
        
    }
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.location.x < UIScreen.main.bounds.width - 157/2 && value.location.y <  UIScreen.main.bounds.height - 240/2 && value.location.x > 157/2 && value.location.y > 240/2{
                    self.location = value.location
                }

            }
    }
    
    func onClose() {
        CallStatusManager.shared.setCallStatus(value: .videoCalling)
    }
    
    func onClick() {
        isScaled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            CallStatusManager.shared.setCallStatus(value: .videoCalling)
        }
        
    }
}
    
    
//
//    struct VideoCallWithChatLayout_Previews: PreviewProvider {
//        static var previews: some View {
//            VideoCallWithChatLayout()
//        }
//    }

