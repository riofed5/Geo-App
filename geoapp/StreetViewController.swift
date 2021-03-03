//
//  StreetViewController.swift
//  geoapp
//
//  Created by iosdev on 23.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import Foundation
import CoreData

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

class StreetViewController: UIViewController {

    @IBOutlet var panoramaView: GMSPanoramaView!
    @IBOutlet weak var guessBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var currentScore: UILabel!
    
    let service = GMSPanoramaService()
    var latCor: Double = 0.00
    var longCor: Double = 0.00
    var panoramaIDCheck:String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.panoramaView.animate(to: GMSPanoramaCamera(heading: 90, pitch: 0, zoom: 1), animationDuration: 2)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Helpers.isChallengeMode = false
        checkForPanorama()
        currentScore.text = "\(Helpers.nor_score)"
        currentScore.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)
        
        // style the buttons
        backBtn.layer.cornerRadius = 8
        backBtn.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)
        
        guessBtn.layer.cornerRadius = 8
        guessBtn.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)
    }
    
    func checkForPanorama() {
        var i:Int=0
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            if users.count != 0 {
                i = Int.random(in: 0 ... 239)
                print(users.count)
                
            }
            else{
                Helpers.nor_score = 0
                i = Int.random(in: 0 ... 2)
                print(users.count)
            }
        }
        let ranLatCor = Double.random(in: -0.05 ... 0.05)
        let ranLongCor = Double.random(in: -0.05 ... 0.05)
        
        self.latCor = (Helpers.places["latCor"]?[i])! + ranLatCor //Double.random(in: -90 ... 90)
        self.longCor = (Helpers.places["longCor"]?[i])! + ranLongCor//Double.random(in: -180 ... 180)
        
        service.requestPanoramaNearCoordinate(CLLocationCoordinate2D(latitude: self.latCor, longitude: self.longCor)) { (panorama, error) in
            if let error = error {
                // No panorama
                print("wrong coordinator")
                print(error.localizedDescription)
                self.checkForPanorama()
                return
            } else if let panorama = panorama {
                print("Panorama id: \(panorama.panoramaID)")
                let location = CLLocation(latitude: self.latCor, longitude: self.longCor)
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    print(city + ", " + country)
                }
                print(i)
                print(self.latCor)
                print(self.longCor)
                self.panoramaView.move(toPanoramaID: panorama.panoramaID)
            } else {
                print("Something went wrong")
            }
        }
        
    }
    
    func updateScore() {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            print(type(of: users))
        if users.count != 0 && Helpers.nor_score > Helpers.cur_score {
        Helpers.databaseRef.child("scores/\(users[0].username!)/\(Helpers.normalMode)").setValue(Helpers.nor_score)}
        }
        Helpers.showHomeView(self)
    }
    
    @IBAction func finish(_ sender: UIButton) {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            if users.count == 0 {
                Helpers.showMainView(self)
            }
            else {
                let alertController = UIAlertController(title: NSLocalizedString("Do you want to quit?", comment: ""), message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: {(action) -> Void in self.updateScore()
                })
                 let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
                alertController.addAction(confirm)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? GuessMapVC
        vc?.answer_coor = CLLocationCoordinate2D(latitude: latCor, longitude: longCor)
    }
}
