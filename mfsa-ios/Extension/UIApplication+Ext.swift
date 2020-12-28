//
//  UIApplication+Ext.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import UIKit

extension UIApplication {
    var firstWindow: UIWindow? {
        get {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                  let window = windowSceneDelegate.window else {
                return nil
            }
            return window
        }
    }
}
