//
//  Unity.swift
//  swiftUnity
//
//  Created by Ahmed Iqbal on 6/22/22.
//

import Foundation
import UnityFramework


class Unity: UIResponder, UIApplicationDelegate {

    // The structure for Unity messages
    private struct UnityMessage {
        let objectName: String?
        let methodName: String?
        let messageBody: String?
    }

    private var cachedMessages = [UnityMessage]() // Array of cached messages
    static let shared = Unity()

    private let dataBundleId: String = "com.unity3d.framework"
    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"

    private var ufw : UnityFramework?
    private var hostMainWindow : UIWindow?

    private var isInitialized: Bool {
        ufw?.appController() != nil
    }

    func show() {
        if isInitialized {
            showWindow()
        } else {
            initWindow()
        }
    }

    func setHostMainWindow(_ hostMainWindow: UIWindow?) {
        self.hostMainWindow = hostMainWindow
    }

    private func initWindow() {
        if isInitialized {
            showWindow()
            return
        }

        guard let ufw = loadUnityFramework() else {
            print("ERROR: Was not able to load Unity")
            return unloadWindow()
        }

        self.ufw = ufw
        ufw.setDataBundleId(dataBundleId)
        ufw.register(self)
        ufw.runEmbedded(
            withArgc: CommandLine.argc,
            argv: CommandLine.unsafeArgv,
            appLaunchOpts: nil
        )

        sendCachedMessages() // Added this line
    }

    private func showWindow() {
        if isInitialized {
            ufw?.showUnityWindow()
            sendCachedMessages() // Added this line
        }
    }

    private func unloadWindow() {
        if isInitialized {
            cachedMessages.removeAll() // Added this line
            ufw?.unloadApplication()
        }
    }

    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + frameworkPath

        let bundle = Bundle(path: bundlePath)
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header

            ufw?.setExecuteHeader(machineHeader)
        }
        return ufw
    }

    // Main method for sending a message to Unity
    func sendMessage(
        _ objectName: String,
        methodName: String,
        message: String
    ) {
        let msg: UnityMessage = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: message
        )

        // Send the message right away if Unity is initialized, else cache it
        if isInitialized {
            ufw?.sendMessageToGO(
                withName: msg.objectName,
                functionName: msg.methodName,
                message: msg.messageBody
            )
        } else {
            cachedMessages.append(msg)
        }
    }

    // Send all previously cached messages, if any
    private func sendCachedMessages() {
        if cachedMessages.count >= 0 && isInitialized {
            for msg in cachedMessages {
                ufw?.sendMessageToGO(
                    withName: msg.objectName,
                    functionName: msg.methodName,
                    message: msg.messageBody
                )
            }

            cachedMessages.removeAll()
        }
    }
}

extension Unity: UnityFrameworkListener {

    func unityDidUnload(_ notification: Notification!) {
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
    }
}

//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//
//public class DongameBehavior : MonoBehaviour
//{
//    void setAuthToken(string authToken)
//    {
//      // print authToken here
//    }
//
//    void setGameId(string gameId)
//    {
//      // print Game Id here
//    }
//
//    void setPlayerIds(string _player_ids)
//    {
//      // print Player Id here
//    }
//
//    void setGameType(string _game_type)
//    {
//      // print GameType here
//    }
//}

//class Unity: UIResponder, UIApplicationDelegate {
//    static let shared = Unity()
//    private let dataBundleId: String = "com.unity3d.framework"
//    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"
//    private var ufw : UnityFramework?
//    private var hostMainWindow : UIWindow?
//    private var isInitialized: Bool {
//        ufw?.appController() != nil
//    }
//
//    func show() {
//        if isInitialized {
//            showWindow()
//        } else {
//            initWindow()
//        }
//    }
//
//    func setHostMainWindow(_ hostMainWindow: UIWindow?) {
//        self.hostMainWindow = hostMainWindow
//    }
//
//    private func initWindow() {
//        if isInitialized {
//            showWindow()
//            return
//        }
//        guard let ufw = loadUnityFramework() else {
//            print("ERROR: Was not able to load Unity")
//            return unloadWindow()
//        }
//        self.ufw = ufw
//        ufw.setDataBundleId(dataBundleId)
//        ufw.register(self)
//        ufw.runEmbedded(
//            withArgc: CommandLine.argc,
//            argv: CommandLine.unsafeArgv,
//            appLaunchOpts: nil
//        )
//    }
//
//    private func showWindow() {
//        if isInitialized {
//            ufw?.showUnityWindow()
//        }
//    }
//
//    private func unloadWindow() {
//        if isInitialized {
//            ufw?.unloadApplication()
//        }
//    }
//
//    private func loadUnityFramework() -> UnityFramework? {
//        let bundlePath: String = Bundle.main.bundlePath + frameworkPath
//        let bundle = Bundle(path: bundlePath)
//        if bundle?.isLoaded == false {
//            bundle?.load()
//        }
//        let ufw = bundle?.principalClass?.getInstance()
//        if ufw?.appController() == nil {
//            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
//            machineHeader.pointee = _mh_execute_header
//            ufw?.setExecuteHeader(machineHeader)
//        }
//        return ufw
//    }
//}
//
//extension Unity: UnityFrameworkListener {
//    func unityDidUnload(_ notification: Notification!) {
//        ufw?.unregisterFrameworkListener(self)
//        ufw = nil
//        hostMainWindow?.makeKeyAndVisible()
//    }
//}
