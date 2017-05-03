//
//  EventsViewController.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var event: Event!
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        let lat = CLLocationDegrees(event.lat!)
        let lon = CLLocationDegrees(event.lon!)
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        
        let annotation = PhotoAnnotation()
        annotation.coordinate = center
        annotation.photo = image
        annotation.title = event.name
        annotation.comment = event.comment
        self.mapView.addAnnotation(annotation)
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "listGroupsSegue" {
            let vc = segue.destination as! GroupsViewController
            vc.event = event
        }
    }
    

}

extension EventViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            //annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50)))
        }
        let imageView = annotationView!.leftCalloutAccessoryView as! UIImageView
        
        var resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = .scaleAspectFill
        resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var thumbnail: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = thumbnail
        
        let detailButton = UIButton(type: .detailDisclosure)
        annotationView!.rightCalloutAccessoryView = detailButton
        //annotationView!.image = imageView.image
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //print(event.eventUrlString!)
        UIApplication.shared.open(URL(string: event.eventUrlString!)!, options: [:], completionHandler: nil)
    }
}
