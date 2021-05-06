//
//  AppDelegate.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

let db = Firestore.firestore()
let studentCollection = db.collection("ios_students")
let markingSchemeCollection = db.collection("ios_schemes")
let weeks = ["week1", "week2", "week3", "week4", "week5", "week6", "week7", "week8", "week9", "week10", "week11", "week12"]
let schemes = ["Attendance", "Multiple Checkpoints", "Score out of x", "Grade Level (HD)", "Grade Level (A)"]
let HDGrades = ["HD+", "HD", "DN", "CR", "PP", "NN"]
let AGrades = ["A", "B", "C", "D", "F"]


// Global students data
public var students = [Student]()

// Global markingScheme data
public var markingScheme = MarkingScheme(schemes: ["week1": "Attendance", "week2": "Attendance", "week3": "Attendance", "week4": "Attendance", "week5": "Attendance", "week6": "Attendance", "week7": "Attendance", "week8": "Attendance", "week9": "Attendance", "week10": "Attendance", "week11": "Attendance", "week12": "Attendance"])

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

