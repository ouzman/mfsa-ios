//
//  UIWindowKey.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import SwiftUI

struct UIWindowKey: EnvironmentKey {
    static var defaultValue: UIWindow?
    typealias Value = UIWindow?
}

extension EnvironmentValues {
    var window: UIWindow? {
        get {
            return self[UIWindowKey.self]
        }
        set {
            self[UIWindowKey.self] = newValue
        }
    }
}
