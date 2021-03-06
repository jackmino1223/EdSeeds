//
//  AppDelegate.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import FBSDKCoreKit
import LinkedinSwift
//import BMPlayer
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    var facebookAppId: String!
    var linkedAppId: String!
    var googleAppId: String!
    var appBundleId: String!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        IQKeyboardManager.sharedManager().enable = true
//        IQKeyboardManager.sharedManager().enableDebugging = true
        
        getAppIds()
        
        FIRApp.configure()
        
        registerRemoteNotification(application)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError!)")
        
        GIDSignIn.sharedInstance().signOut()
        
        BMPlayerConf.shouldAutoPlay = false
        
        STPPaymentConfiguration.shared().publishableKey = PaymentAppKey.Stripe // "pk_test_JOUcqKGRpMCAkc3MEZKfYBq6"
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction : PaymentAppKey.PaypalProduction,
                                                               PayPalEnvironmentSandbox    : PaymentAppKey.PaypalSandbox]) //[PayPalEnvironmentNoNetwork: "no network"])
        
//        GIDSignIn.sharedInstance().delegate = self

        return true
    }
    
    fileprivate func getAppIds() {
        facebookAppId = "fb" + (Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as! String)
        linkedAppId   = "li" + (Bundle.main.object(forInfoDictionaryKey: "LIAppId") as! String)
        
        if let fileUrl = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] { // [String: Any] which ever it is
                googleAppId = result!["REVERSED_CLIENT_ID"] as! String
            }
        }
        appBundleId = Bundle.main.bundleIdentifier!

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme {
            if scheme == facebookAppId {
                let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
                return handle
            } else if scheme == linkedAppId {
                if LinkedinSwiftHelper.shouldHandle(url) {
                    let handle = LinkedinSwiftHelper.application(app,
                                                                  open: url,
                                                                  sourceApplication: options[.sourceApplication] as? String,
                                                                  annotation: options[.annotation])
                    return handle
                }
            } else if scheme == googleAppId {
                return GIDSignIn.sharedInstance().handle(url,
                                                         sourceApplication: options[.sourceApplication] as? String,
                                                         annotation: options[.annotation])

            }
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let scheme = url.scheme {
            if scheme == facebookAppId {
                let handle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
                return handle
            } else if scheme == linkedAppId {
                if LinkedinSwiftHelper.shouldHandle(url) {
                    let handle = LinkedinSwiftHelper.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
                    return handle
                }
            } else if scheme == googleAppId {
                return GIDSignIn.sharedInstance().handle(url,
                                                         sourceApplication: sourceApplication,
                                                         annotation: annotation)
                
            }
        }
            return false
    }
    
    // MARK: - Remote notification
    func registerRemoteNotification(_ application: UIApplication) -> Void {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]

    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            ESAppManager.sharedManager.fcmRefreshToken = refreshedToken
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error!.localizedDescription)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]

