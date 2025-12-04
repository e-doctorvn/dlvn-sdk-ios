import SwiftUI
import WebKit


struct StartCallScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var directCallManager = DirectCallManager.shared
    @ObservedObject var callStatusManager = CallStatusManager.shared
    
    var body: some View {
        VStack {
            if callStatusManager.callStatus == .videoCalling || callStatusManager.callStatus == .calling {
                VideoCallScreen().environmentObject(directCallManager)
                    .environmentObject(callStatusManager)
            } else if callStatusManager.callStatus == .videoCallWithChat {
                VideoCallWithChatLayout()
                    .environmentObject(directCallManager)
            } else {
                ZStack {
                       Color.black.edgesIgnoringSafeArea(.all)
                       
                       VStack {
                           Spacer()
                           
                           Image(systemName: "person.crop.circle.fill")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .frame(width: 120, height: 120)
                               .clipShape(Circle())
                               .padding(.bottom, 20)
                           
                           Text("Calling...")
                               .font(.title)
                               .foregroundColor(.white)
                           
                           Text(directCallManager.directCall?.callee?.nickname ?? "Đang kết nối....")
                               .font(.subheadline)
                               .foregroundColor(.gray)
                           
                           Spacer()
                           
                           HStack {
                               Spacer()
                               
                               Button(action: {
                                   directCallManager.endCallFast()
                                   presentationMode.wrappedValue.dismiss()
                               }) {
                                   Image(systemName: "phone.down.fill")
                                       .font(.system(size: 25))
                                       .foregroundColor(.red)
                                       .padding()
                                       .background(Color.white.opacity(0.2))
                                       .clipShape(Circle())
                               }
                               .padding(.horizontal, 20)
                           }
                       }
                   }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            if let presentingViewController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
                presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
        .onChange(of: callStatusManager.callStatus) { newValue in
            if newValue == .finish {
                onClose()
            }
        }
    }
    
    
    func onClose () {
        presentationMode.wrappedValue.dismiss()
    }
}

