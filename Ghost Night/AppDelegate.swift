//
//  AppDelegate.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/3/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import GoogleMobileAds
import IQKeyboardManagerSwift
import FBSDKLoginKit
import UserNotifications
import GhostNightPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UserHelper.share.syncUserInfo()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // setCustom UI
        setUINavigationBar()
        
        //UIApplication.shared.statusBarStyle = .lightContent
        
        _ = AudioPlayerManager.shared
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        AppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        let viewController = window?.rootViewController as! ViewController
//        viewController.disconnectAVPlayer()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        let viewController = window?.rootViewController as! ViewController
//        viewController.reconnectAVPlayer()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // MAKE :- PushNotifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        debugPrint("Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        debugPrint("Messaging.messaging().apnsToken : \(String(describing: Messaging.messaging().apnsToken))")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("Failed to register: \(error)")
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // Display Notification.
    fileprivate func showNotification(message: String) {
        print("showNotification")
        if #available(iOS 10.0, *) {
            // Generate Notification.
            let content = UNMutableNotificationContent()
            
            // Substitute Title.
            content.title = "Ghost Night Notification"
            
            // Assign Body.
            content.body = message
            
            // Set the sound.
            content.sound = UNNotificationSound.default
            
            // Generate a Request.
            let request = UNNotificationRequest.init(identifier: "notification1", content: content, trigger: nil)
            
            // issue a Notification.
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error?.localizedDescription ?? "")
            }
        } else {
            // Fallback on earlier versions
            
            // Generate Notification.
            let notification = UILocalNotification()
            
            // Substitute Title.
            notification.alertTitle = "Ghost Night Notification"
            
            // Assign Body.
            notification.alertBody = message
            
            // Set the sound.
            notification.soundName = UILocalNotificationDefaultSoundName
            
            // issue a Notification.
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
}

// MARK :- MessagingDelegate
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    /*
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
     */
    // [END ios_10_data_message]
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint("UNUserNotificationCenter")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject], let message = aps["alert"] as? String  else {
            completionHandler(.failed)
            return
        }
        debugPrint("didReceiveRemoteNotification")
        showNotification(message: message)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }
}

// MARK :- Custom
extension AppDelegate {
    fileprivate func setUINavigationBar() {
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = UIColor.gray
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
    }
}

class NavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }
}


