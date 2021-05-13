//
//  SubmitInfoViewController.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/9/21.
//

import UIKit
import Parse

class AddPackageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // @IBOutlet weak var trackNumInput: UITextField!
    // @IBOutlet weak var carrierInput: UITextField!
    // @IBOutlet weak var addPackageButton: UIButton!
    @IBOutlet weak var addPackageButton: UIBarButtonItem!
    // @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var inputsTableView: UITableView!
    var feedVC: UIViewController!
    
    @objc func tableTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.inputsTableView)
        let path = self.inputsTableView.indexPathForRow(at: location)
        if path == nil {
            // print("blank!")
            self.view.endEditing(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPackageButton.style = .done
        // inputsTableView.delegate = self
        // inputsTableView.dataSource = self
        inputsTableView.register(UINib(nibName: "TextInputTableViewCell", bundle: nil), forCellReuseIdentifier: "TextInputTableViewCell")
        inputsTableView.register(UINib(nibName: "DropdownTableViewCell", bundle: nil), forCellReuseIdentifier: "DropdownTableViewCell")
        inputsTableView.dataSource = self
        inputsTableView.tableFooterView = UIView()
        inputsTableView.tableFooterView?.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.inputsTableView.addGestureRecognizer(tap)
        // self.inputsTableView.contentInset.top = 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell", for: indexPath) as! TextInputTableViewCell
        if (indexPath.row == 0) {
            cell.textfield.placeholder = "Package name"
            cell.selectionStyle = .none
        } else if (indexPath.row == 1) {
            cell.textfield.placeholder = "Tracking number"
            cell.selectionStyle = .none
        } else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell", for: indexPath) as! DropdownTableViewCell
            cell.selectionStyle = .default
            return cell
            // cell.textfield.placeholder = "Carrier"
        }
        
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let name = (inputsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextInputTableViewCell).textfield.text!
        let trackNum = (inputsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextInputTableViewCell).textfield.text!
        let carrier = (inputsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DropdownTableViewCell).carrierLabel.text!
        if (name.count < 1) || (trackNum.count < 1) {
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter a package name and tracking number.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        } else {
            print(name)
            print(trackNum)
            print(carrier)
            let package = PFObject(className: "Packages")
            package["author"] = PFUser.current()
            package["name"] = name
            package["tracking_number"] = trackNum
            package["carrier"] = carrier
            package.saveInBackground { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: {
                        // print("test")
                        // let feedViewController = self.presentingViewController as! FeedViewController
                        let feedVC2 = self.feedVC as! FeedViewController
                        feedVC2.viewDidLoad()
                    })
                    print("saved!")
                } else {
                    let alert = UIAlertController(title: "Error", message: "Server error.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
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
