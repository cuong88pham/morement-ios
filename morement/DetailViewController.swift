//
//  DetailViewController.swift
//  morement
//
//  Created by Cuong Pham on 7/5/15.
//  Copyright © 2015 morement.vn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HALLO I'M DETAIL"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
