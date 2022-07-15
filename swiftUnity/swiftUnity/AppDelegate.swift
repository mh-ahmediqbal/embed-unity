//
//  AppDelegate.swift
//  swiftUnity
//
//  Created by Ahmed Iqbal on 6/22/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Unity.shared.setHostMainWindow(window)
        return true
        
    }
}

