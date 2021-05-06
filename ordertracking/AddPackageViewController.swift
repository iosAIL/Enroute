//
//  SubmitInfoViewController.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/9/21.
//

import UIKit
import Parse

class AddPackageViewController: UIViewController {
    
    @IBOutlet weak var trackNumInput: UITextField!
    @IBOutlet weak var carrierInput: UITextField!
    // @IBOutlet weak var addPackageButton: UIButton!
    @IBOutlet weak var addPackageButton: UIBarButtonItem!
    @IBOutlet weak var nameInput: UITextField!
    var feedVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let feedVC2 = self.feedVC as! FeedViewController
        // print(feedVC2.expectingLabel.text!)
    
        // addPackageButton.layer.cornerRadius = 7
        // nameInput.placeholder = "Package Enroute"
        // trackNumInput.placeholder = "123456789"
        // carrierInput.placeholder = "fedex"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    @IBAction func cancelAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }*/
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let package = PFObject(className: "Packages")
        
        package["author"] = PFUser.current()
        package["tracking_number"] = trackNumInput.text!
        package["carrier"] = carrierInput.text!
        package["name"] = nameInput.text!.isEmpty ? "Package Enroute" : nameInput.text!
        
        package.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: {
                    print("test")
                    // let feedViewController = self.presentingViewController as! FeedViewController
                    let feedVC2 = self.feedVC as! FeedViewController
                    feedVC2.viewDidLoad()
                })
                print("saved!")
            } else {
                print("error!")
            }
        }
        
        // let feedViewController = self.parent?.parent as! FeedViewController
        // let feedViewController = nav.topViewController as! FeedViewController
        // feedViewController.refreshStatusOfAllPackages()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let trackViewController = nav.topViewController as? TrackViewController {
            trackViewController.setTrackingNumAndCarrier(trackNumInput.text, carrierInput.text)
        }
    }*/
}
