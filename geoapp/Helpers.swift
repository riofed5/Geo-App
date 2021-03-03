//
//  Helpers.swift
//  geoapp
//
//  Created by Quan Dao on 25.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import CoreData

public class Helpers {
    static var questionNumber: Int = 0
    static var isChallengeMode: Bool = false
    static var cha_score: Int = 0
    static var curcha_score: Int = 0
    static var nor_score: Int = 0
    static var cur_score: Int = 0
    enum Modes: String {
        case normal = "Normal"
        case challenge = "Challenge"
    }
    
    static var normalMode: String = Modes.normal.rawValue
    static var challengeMode: String = Modes.challenge.rawValue
    
    static var databaseRef:DatabaseReference = Database.database().reference()
    
    static func signIn(loginInfo : Dictionary<String, String>, viewController : UIViewController) {
        AF.request("http://media.mw.metropolia.fi/wbma/login", method: .post, parameters: loginInfo).validate().responseJSON {response in
            if (response.value == nil) {
                let alert = UIAlertController(title: NSLocalizedString("Failed to sign in", comment: ""), message: NSLocalizedString("Username or password is incorrect.", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                viewController.present(alert, animated: true)
                return
            }
            
            let token = (response.value as! NSDictionary)["token"] as! String
            let user = (response.value as! NSDictionary)["user"] as! NSDictionary
            let username = user["username"] as! String
            
            setNewUserInfo(token: token, username: username)
            
            showHomeView(viewController)
        };
    }
    
    static func setNewUserInfo(token: String, username: String) {
        let userInfo = try? UserInfo.getOrCreateUserInfoWith(token: token)
        userInfo?.token = token
        userInfo?.username = username
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    static func showHomeView(_ viewController: UIViewController) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)

        let homeViewController = storyBoard.instantiateInitialViewController() as! HomeVC
        viewController.present(homeViewController, animated:true, completion:nil)
    }
    
    static func showMainView(_ viewController: UIViewController) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let mainViewController = storyBoard.instantiateInitialViewController() as! MainViewController
        viewController.present(mainViewController, animated:true, completion:nil)
    }
    
    static func showRegisterView(_ viewController: UIViewController) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Register", bundle:nil)

        let registerViewController = storyBoard.instantiateInitialViewController() as! RegisterViewController
        viewController.present(registerViewController, animated:true, completion:nil)
    }

    static var places = ["latCor":[21.03333333,10.784347,16.067786,34.51666667,60.116667,41.31666667,36.75,
        -14.26666667,
        42.5,
        -8.833333333,
        18.21666667,
        17.11666667,
        -34.58333333,
        40.16666667,
        12.51666667,
        -35.26666667,
        48.2,
        40.38333333,
        25.08333333,
        26.23333333,
        23.71666667,
        13.1,
        53.9,
        50.83333333,
        17.25,
        6.483333333,
        32.28333333,
        27.46666667,
        -16.5,
        43.86666667,
        -24.63333333,
        -15.78333333,
        -7.3,
        18.41666667,
        4.883333333,
        42.68333333,
        12.36666667,
        -3.366666667,
        11.55,
        3.866666667,
        45.41666667,
        14.91666667,
        19.3,
        4.366666667,
        12.1,
        -33.45,
        39.91666667,
        -10.41666667,
        -12.16666667,
        4.6,
        -11.7,
        -21.2,
        9.933333333,
        6.816666667,
        45.8,
        23.11666667,
        12.1,
        35.16666667,
        50.08333333,
        -4.316666667,
        55.66666667,
        11.58333333,
        15.3,
        18.46666667,
        -0.216666667,
        30.05,
        13.7,
        3.75,
        15.33333333,
        59.43333333,
        9.033333333,
        -51.7,
        62,
        6.916666667,
        -18.13333333,
        60.16666667,
        48.86666667,
        -17.53333333,
        0.383333333,
        41.68333333,
        52.51666667,
        5.55,
        36.13333333,
        37.98333333,
        64.18333333,
        12.05,
        13.46666667,
        14.61666667,
        49.45,
        9.5,
        11.85,
        6.8,
        18.53333333,
        14.1,
        47.5,
        64.15,
        28.6,
        -6.166666667,
        35.7,
        33.33333333,
        53.31666667,
        54.15,
        31.76666667,
        41.9,
        18,
        35.68333333,
        49.18333333,
        31.95,
        51.16666667,
        -1.283333333,
        -0.883333333,
        42.66666667,
        29.36666667,
        42.86666667,
        17.96666667,
        56.95,
        33.86666667,
        -29.31666667,
        6.3,
        32.88333333,
        47.13333333,
        54.68333333,
        49.6,
        42,
        -18.91666667,
        -13.96666667,
        3.166666667,
        4.166666667,
        12.65,
        35.88333333,
        7.1,
        18.06666667,
        -20.15,
        19.43333333,
        47,
        43.73333333,
        47.91666667,
        42.43333333,
        16.7,
        34.01666667,
        -25.95,
        16.8,
        -22.56666667,
        -0.5477,
        27.71666667,
        52.35,
        -22.26666667,
        -41.3,
        12.13333333,
        13.51666667,
        9.083333333,
        -19.01666667,
        -29.05,
        39.01666667,
        35.183333,
        15.2,
        59.91666667,
        23.61666667,
        33.68333333,
        7.483333333,
        31.76666667,
        8.966666667,
        -9.45,
        -25.26666667,
        -12.05,
        14.6,
        -25.06666667,
        52.25,
        38.71666667,
        18.46666667,
        25.28333333,
        -4.25,
        44.43333333,
        55.75,
        -1.95,
        17.88333333,
        -15.93333333,
        17.3,
        14,
        18.0731,
        46.76666667,
        13.13333333,
        -13.81666667,
        43.93333333,
        0.333333333,
        24.65,
        14.73333333,
        44.83333333,
        -4.616666667,
        8.483333333,
        1.283333333,
        18.01666667,
        48.15,
        46.05,
        -9.433333333,
        2.066666667,
        9.55,
        -25.7,
        -54.283333,
        37.55,
        4.85,
        40.4,
        6.916666667,
        15.6,
        5.833333333,
        78.21666667,
        -26.31666667,
        59.33333333,
        46.91666667,
        33.5,
        25.03333333,
        38.55,
        -6.8,
        13.75,
        13.45,
        -8.583333333,
        6.116666667,
        -9.166667,
        -21.13333333,
        10.65,
        36.8,
        39.93333333,
        37.95,
        21.46666667,
        -8.516666667,
        0.316666667,
        50.43333333,
        24.46666667,
        51.5,
        38.883333,
        -34.85,
        18.35,
        41.31666667,
        -17.73333333,
        41.9,
        10.48333333,
        21.03333333,
        -13.95,
        15.35,
        -15.41666667,
        -17.81666667], "longCor":[105.85, 106.666345, 108.209624, 69.183333,19.9,19.816667,3.05,
        -170.7,
        1.516667,
        13.216667,
        -63.05,
        -61.85,
        -58.666667,
        44.5,
        -70.033333,
        149.133333,
        16.366667,
        49.866667,
        -77.35,
        50.566667,
        90.4,
        -59.616667,
        27.566667,
        4.333333,
        -88.766667,
        2.616667,
        -64.783333,
        89.633333,
        -68.15,
        18.416667,
        25.9,
        -47.916667,
        72.4,
        -64.616667,
        114.933333,
        23.316667,
        -1.516667,
        29.35,
        104.916667,
        11.516667,
        -75.7,
        -23.516667,
        -81.383333,
        18.583333,
        15.033333,
        -70.666667,
        116.383333,
        105.716667,
        96.833333,
        -74.083333,
        43.233333,
        -159.766667,
        -84.083333,
        -5.266667,
        16,
        -82.35,
        -68.916667,
        33.366667,
        14.466667,
        15.3,
        12.583333,
        43.15,
        -61.4,
        -69.9,
        -78.5,
        31.25,
        -89.2,
        8.783333,
        38.933333,
        24.716667,
        38.7,
        -57.85,
        -6.766667,
        158.15,
        178.416667,
        24.933333,
        2.333333,
        -149.566667,
        9.45,
        44.833333,
        13.4,
        -0.216667,
        -5.35,
        23.733333,
        -51.75,
        -61.75,
        144.733333,
        -90.516667,
        -2.533333,
        -13.7,
        -15.583333,
        -58.15,
        -72.333333,
        -87.216667,
        19.083333,
        -21.95,
        77.2,
        106.816667,
        51.416667,
        44.4,
        -6.233333,
        -4.483333,
        35.233333,
        12.483333,
        -76.8,
        139.75,
        -2.1,
        35.933333,
        71.416667,
        36.816667,
        169.533333,
        21.166667,
        47.966667,
        74.6,
        102.6,
        24.1,
        35.5,
        27.483333,
        -10.8,
        13.166667,
        9.516667,
        25.316667,
        6.116667,
        21.433333,
        47.516667,
        33.783333,
        101.7,
        73.5,
        -8,
        14.5,
        171.383333,
        -15.966667,
        57.483333,
        -99.133333,
        28.85,
        7.416667,
        106.916667,
        19.266667,
        -62.216667,
        -6.816667,
        32.583333,
        96.15,
        17.083333,
        166.920867,
        85.316667,
        4.916667,
        166.45,
        174.783333,
        -86.25,
        2.116667,
        7.533333,
        -169.916667,
        167.966667,
        125.75,
        33.366667,
        145.75,
        10.75,
        58.583333,
        73.05,
        134.633333,
        35.233333,
        -79.533333,
        147.183333,
        -57.666667,
        -77.05,
        120.966667,
        -130.083333,
        21,
        -9.133333,
        -66.116667,
        51.533333,
        15.283333,
        26.1,
        37.6,
        30.05,
        -62.85,
        -5.716667,
        -62.716667,
        -61,
        -63.0822,
        -56.183333,
        -61.216667,
        -171.766667,
        12.416667,
        6.733333,
        46.7,
        -17.633333,
        20.5,
        55.45,
        -13.233333,
        103.85,
        -63.033333,
        17.116667,
        14.516667,
        159.95,
        45.333333,
        44.05,
        28.216667,
        -36.5,
        126.983333,
        31.616667,
        -3.683333,
        79.833333,
        32.533333,
        -55.166667,
        15.633333,
        31.133333,
        18.05,
        7.466667,
        36.3,
        121.516667,
        68.766667,
        39.283333,
        100.516667,
        -16.566667,
        125.6,
        1.216667,
        -171.833333,
        -175.2,
        -61.516667,
        10.183333,
        32.866667,
        58.383333,
        -71.133333,
        179.216667,
        32.55,
        30.516667,
        54.366667,
        -0.083333,
        -77,
        -56.166667,
        -64.933333,
        69.25,
        168.316667,
        12.45,
        -66.866667,
        105.85,
        -171.933333,
        44.2,
        28.283333,
        31.033333
    ]]
}