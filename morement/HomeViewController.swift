//
//  ViewController.swift
//  morement
//
//  Created by Cuong Pham on 7/4/15.
//  Copyright © 2015 morement.vn. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

import CoreLocation

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var AddressLabel: UILabel!

    @IBOutlet weak var _collectionView: UICollectionView!
    let picker = UIImagePickerController()
    private let identifyCell = "Cell"
    let customer_key = "m37WQdARdlzcPXgcpw0n6jj2j2YgUoEDXaowSUi5"
    let customer_sc  = "jrwgXazx7Ac3b6Hu7XvJWha2rEnpg1Ktmptxa1Zp"
    let searchAllApiUrl: String = "https://api-us.clusterpoint.com/100693/Media/_search/*/12/0/.json"
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var currentPage:Int = 1
    let perPage = 12
    var totalPage = 1
    var moreData  = 0
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    @IBOutlet weak var captureButton: UIButton!
    
    @IBAction func captureTouch(sender: UIButton) {
        
    }
    
    var items:NSMutableArray = []
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Near You"
        self._collectionView.dataSource = self
        self._collectionView.delegate   = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        getCoords(0.0, lng: 0.0)
        getData(1, lat: 0.0, lng: 0.0)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(123)
    }
    
    func getCoords(lat: Double, lng: Double){
        Alamofire.request(.GET, URLString: "http://130.211.244.98/location.php?lat=10.723333700000001&long=106.71543799999999").responseString(){
            (_, _, string, _) in
            self.AddressLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            self.AddressLabel.numberOfLines = 3
            self.AddressLabel.text = "100 meters around " + string!
        }
    }

    
    func getData(page: Int, lat: Double, lng: Double){
        var _page = (page - 1)  * self.perPage
        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hub.mode = MBProgressHUDMode.Indeterminate
        hub.labelText = "Loading..."
        
        let formatter = NSDateFormatter()
//        formatter.dateStyle = NSDateFormatterStyle.LongStyle
//        formatter.timeStyle = .MediumStyle
        formatter.dateFormat = "dd-MM-yyyy HH:mm"

        let url = "https://api-us.clusterpoint.com/100693/Media/_search/*/\(self.perPage)/\(_page)/.json"
        Alamofire
            .request(.GET, URLString: url).authenticate(user: "harry88pham@gmail.com", password: "12344321").responseJSON() {
                (_, _, data, _) in
                
                let photos = data!.valueForKey("documents") as! [NSDictionary]
                self.items.addObjectsFromArray(photos)
                var temp:NSMutableArray = []
                
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let hits =  (data!.valueForKey("hits")! as! String)
                self.totalPage = Int(hits)! / self.perPage
                self.moreData  = Int((data!.valueForKey("more")! as! String).stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))!
                self._collectionView.reloadData()
                
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.moreData  > 0 {
            self.currentPage++
            getData(self.currentPage, lat: self.lat, lng: self.lng )
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
//
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var item = self.items.objectAtIndex(indexPath.row)
        
        var DetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let imageUrl: String = item.valueForKey("url")! as! String
        let image: UIImage =  UIImage(data: NSData(contentsOfURL: NSURL(string: imageUrl as String)!)!)!
        if var detailImage = DetailVC.detailImage{
            detailImage.image = image
        }
//        DetailVC.detailImage.image = image
//        print(image)
        self.navigationController!.presentViewController(DetailVC, animated: true, completion: nil)
    }
    

    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let headerView =
//        collectionView.dequeueReusableSupplementaryViewOfKind(kind,
//            withReuseIdentifier: "collectionHeader",
//            forIndexPath: indexPath)
//            as! UICollectionReusableView
//
//    }
    
    func  collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: imageCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifyCell, forIndexPath: indexPath) as! imageCell
        let item = self.items.objectAtIndex(indexPath.row)
        let imageUrl: String = item.valueForKey("url")! as! String
        let thumb = imageUrl.stringByReplacingOccurrencesOfString("media", withString: "media/thumbs", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.layer.cornerRadius = 5

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //load the image in the background
            let image: UIImage =  UIImage(data: NSData(contentsOfURL: NSURL(string: thumb as String)!)!)!

            image.CGImage // <- Force UIImage to not lazy load the data
            //when done, assign it to the cell's UIImageView
            dispatch_async(dispatch_get_main_queue(), {
                if let imageView = cell.imageView {
                    imageView.image = image
                }
            })
        })
        
        
        return cell
    }
    
    func showCamare(){
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        }else{
//            noCamera()
        }
    }
    

}

