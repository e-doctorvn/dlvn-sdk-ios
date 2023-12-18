//
//  AvatarView.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 15/08/2023.
//

import SwiftUI

@available(iOS 14.3, *)
struct AvatarView: View, Equatable {
    var UrlString: String?
    var size: CGFloat
    
    var body: some View {
        if #available(iOS 15.0, *), UrlString != nil {
            AsyncImage(url: URL(string: UrlString!)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: size, height: size)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size, height: size)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size, height: size)
                                .clipShape(Circle())
                        @unknown default:
                            EmptyView()
                        }
                    }
            
        } else {
            if UrlString != nil {
                ImageView(url: URL(string: UrlString!))
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        }
    }
}
