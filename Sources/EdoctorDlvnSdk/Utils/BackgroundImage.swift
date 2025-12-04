//
//  BackgroundImage.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 17/08/2023.
//

import SwiftUI
//               Image("backgroundCall", bundle: isCocoapod ? Bundle(for: WebViewController.self) : Bundle.module)

struct BackgroundImage: View, Encodable {
    let UrlString: String?
    let blur: CGFloat
    var body: some View {
        if #available(iOS 15.0, *), UrlString != nil {
            AsyncImage(url: URL(string: UrlString!)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: blur)
                    .opacity(0.7)
            } placeholder: {
                Image("backgroundCall", bundle: Bundle(for: WebViewController.self))
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            }
        } else {
            if UrlString != nil {
                ImageView(url: URL(string: UrlString!))
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: blur)
            } else {
                Image("backgroundCall", bundle: Bundle(for: WebViewController.self))
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            }

        }

    }
}

//struct BackgroundImage_Previews: PreviewProvider {
//    static var previews: some View {
//        BackgroundImage()
//    }
//}
