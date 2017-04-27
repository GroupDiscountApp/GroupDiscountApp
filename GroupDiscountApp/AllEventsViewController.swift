//
//  AllEventsViewController.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class AllEventsViewController: UICollectionViewController {

    var events: [Event]!
    var filtered: [Event]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var locationManager: CLLocationManager!
    var lastLocation : CLLocationCoordinate2D!
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // user location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        */
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        //collectionView!.backgroundColor = UIColor.clear
        //collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: (collectionView?.contentSize.height)!, width: (collectionView?.bounds.size.width)!, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionView?.addSubview(loadingMoreView!)
        
        var insets = collectionView?.contentInset
        insets?.bottom += InfiniteScrollActivityView.defaultHeight
        collectionView?.contentInset = insets!
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        //navigationController?.navigationBar.barTintColor = UIColor.red
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EventViewController
        let indexPath = collectionView?.indexPathsForSelectedItems?.first
        let cell = sender as! AnnotatedPhotoCell
        vc.image = cell.imageView.image
        let event = filtered[(indexPath?.item)!]
        vc.event = event
    }
    
}

extension AllEventsViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filtered != nil {
            return filtered!.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCell", for: indexPath) as! EventsCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        
        cell.event = filtered![indexPath.item]
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = collectionView?.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight! - (collectionView?.bounds.size.height)!
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && (collectionView?.isDragging)!) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: (collectionView?.contentSize.height)!, width: (collectionView?.bounds.size.width)!, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                let start = self.collectionView?.numberOfItems(inSection: 0)
                
                Event.searchWith(q: "", sort: nil, start: start, point: lastLocation) { (events: [Event]?, error: Error?) in
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                    self.events! += events!
                    self.filtered = self.events
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                    self.collectionView?.reloadData()
                }
            }
        }
    }
}

extension AllEventsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        let stat = CLLocationManager.authorizationStatus()
        if (!CLLocationManager.locationServicesEnabled() ||
            stat == CLAuthorizationStatus.notDetermined ||
            stat == CLAuthorizationStatus.restricted ||
            stat == CLAuthorizationStatus.denied) {
            Event.searchWith(q: "") { (events: [Event]?, error: Error?) in
                self.events = events
                self.filtered = events
                self.collectionView?.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations.first as? CLLocation
        lastLocation = location?.coordinate
        
        Event.searchWith(q: "", sort: nil, start: nil, point: lastLocation) { (events: [Event]?, error: Error?) in
            self.events = events
            self.filtered = events
            self.collectionView?.reloadData()
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let err = error as! CLError
        switch err.code {
        case CLError.network:
            var alert = UIAlertView(title: "Location Error!", message: "Can't access your current location! Please check your network connection or that you are not in airplane mode!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "")
            alert.show()
        case CLError.denied:
            var alert = UIAlertView(title: "Location Error!", message: "Location Access has been denied for app name!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "")
            // alert.tag=500;
            alert.show()
        default:
            var alert = UIAlertView(title: "Location Error!", message: "Can't access your current location!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "")
        }
    }
}

extension AllEventsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.isEmpty ? events : events.filter { (item: Event) -> Bool in
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        collectionView?.reloadData()
    }
}

extension AllEventsViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        let event = filtered[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let imageSize = CGSize(width: CGFloat(event.imageWidth!), height: CGFloat(event.imageHeight!))
        let rect  = AVMakeRect(aspectRatio: imageSize, insideRect: boundingRect)
        return rect.size.height
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        
        let event = filtered[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = event.heightForComment(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}
