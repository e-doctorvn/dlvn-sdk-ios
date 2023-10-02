//
//  controller.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 25/09/2023.
//

import Foundation
import UIKit


public class ControlerAlert {
    
    static let shared = ControlerAlert()
    
    public var viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController
    
    public func setViewController(value : UIViewController) {
        viewController = value
    }
    
    public func reSetViewController() {
        viewController = UIApplication.shared.windows.first?.rootViewController
    }
    
}
