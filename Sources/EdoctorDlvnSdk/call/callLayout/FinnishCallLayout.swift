//
//  FinnishCallLayout.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 18/08/2023.
//

import SwiftUI


struct FinnishCallLayout: View {
    
    @State var rating = 5
//    var onClose: (() -> Void)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    
                    Text("Phiên tư vấn đã kết thúc.").font(
                        Font.custom("Inter", size: 22)
                        .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    
                    HStack {
                        ForEach(1..<6) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(star <= rating ? .yellow : .white)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }.padding()
                    
                    Button(action: {
                        CallStatusManager.shared.setCallStatus(value: .none)
                    }) {
                        Text("Gửi đánh giá")
                            .font(.headline)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.gray)

                Button(action: {
                    CallStatusManager.shared.setCallStatus(value: .none)
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 24))
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .position(x: geometry.size.width - 60, y: 100)
                .padding()
            }
            
            

        }

        .edgesIgnoringSafeArea(.all)
    }
}

//struct FinnishCallLayout_Previews: PreviewProvider {
//    static var previews: some View {
//        FinnishCallLayout()
//    }
//}
