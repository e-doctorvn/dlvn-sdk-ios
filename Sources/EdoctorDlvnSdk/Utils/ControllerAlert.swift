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
    
    public var viewController: UIViewController? = UIApplication.topViewController()
    
    public func setViewController(value : UIViewController) {
        DispatchQueue.main.async {
            self.viewController = value
            self.isActive = true
        }
    }
    
    
    public func reSetViewController() {
        DispatchQueue.main.async {
            self.viewController = UIApplication.topViewController()
            self.isActive = false
        }

    }
    
}
