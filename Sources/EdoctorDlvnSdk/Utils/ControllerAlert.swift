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
    var isActive = false
    
    public var viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController
    
    public func setViewController(value : UIViewController) {
        DispatchQueue.main.async {
            self.viewController = value
            self.isActive = true
        }
    }
    
    public func reSetViewController() {
        DispatchQueue.main.async {
            self.viewController = UIApplication.shared.windows.first?.rootViewController
            self.isActive = false
        }

    }
    
}
