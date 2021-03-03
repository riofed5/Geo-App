//
//  GuessMapVC.swift
//  geoapp
//
//  Created by iosdev on 23.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import GoogleMaps

class GuessMapVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var confBtn: UIButton!
    @IBOutlet weak var mguessView: GMSMapView!
    var descoordinate = CLLocationCoordinate2D()
    var answer_coor = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 33, longitude: 68, zoom: 1)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        self.view.addSubview(confBtn)
        mapView.delegate = self
        
        // style the buttons
        confBtn.layer.cornerRadius = 8
        confBtn.backgroundColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
    }
 
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       mapView.clear()
       self.descoordinate = coordinate
       let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
       let marker = GMSMarker(position: position)
       marker.map = mapView
   }
    @IBAction func confirm(_ sender: Any) {
        if descoordinate.latitude == 0.0 {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You haven't made a guess.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AnswerVC
        vc.descoordinate = descoordinate
        vc.answer_coor = answer_coor
    }
}
