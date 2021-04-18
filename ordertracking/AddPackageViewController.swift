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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addPackageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 7
        addPackageButton.layer.cornerRadius = 7
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let package = PFObject(className: "Packages")
                
        package["author"] = PFUser.current()
        package["tracking_number"] = trackNumInput.text!
        package["carrier"] = carrierInput.text!
        
        package.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
       
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let trackViewController = nav.topViewController as? TrackViewController {
            trackViewController.setTrackingNumAndCarrier(trackNumInput.text, carrierInput.text)
        }
    }*/
}
