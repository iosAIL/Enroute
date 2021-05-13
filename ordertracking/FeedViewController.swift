//
//  FeedViewController.swift
//  ordertracking
//
//  Created by Iman Ali on 4/17/21.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var expectingLabel: UILabel!
    
    var packages = [PFObject]()
    var expecting = 0;
    var statusForTrackingNum = [String: String]()
    var currentUser = PFUser.current()
    var trackingNum = "";
    var carrier = "";
    var totalRefreshedSoFar = [String]();
    
    //pull to refresh NEED UPDATING PKG TO TEST
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.expectingLabel.text = "Fetching packages..."
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableview.refreshControl = refreshControl
        
        userLabel.text = currentUser?.username
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        let query = PFQuery(className:"Packages")
        query.whereKey("author", equalTo: currentUser!)
        query.limit = 20
        
        query.findObjectsInBackground { (packages, error) in
            if packages != nil {
                self.packages = packages!
            }
            self.refreshStatusOfAllPackages()
        }
    }
    
    @IBAction func onAddPackage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "addPackageNav") as! UINavigationController
        let addPackageVC = nav.topViewController as! AddPackageViewController
        addPackageVC.feedVC = self
        self.present(nav, animated: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("refreshing")
        
        let query = PFQuery(className:"Packages")
        query.whereKey("author", equalTo: currentUser!)
        query.limit = 20
        
        query.findObjectsInBackground { (packages, error) in
            if packages != nil {
                self.packages = packages!
                self.refreshStatusOfAllPackages()
            }
        }
        
        refreshControl.endRefreshing()
    }
    
    //delete package
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objId=(packages[indexPath.row].objectId)!
            let query = PFQuery(className:"Packages")
            query.getObjectInBackground(withId: objId) {
            (parseObject, error) in
               if error != nil {
                print(error!)
               } else if parseObject != nil {
                self.tableview.beginUpdates()
                self.packages.remove(at: indexPath.row)
                self.tableview.deleteRows(at: [indexPath], with: .fade)
                parseObject?.deleteInBackground()
                self.tableview.endUpdates()
               }
             }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        // loginViewController.modalPresentationStyle = .fullScreen
        // self.present(loginViewController, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    @objc public func updateExpectingPackages() {
        self.expectingLabel.text = "Expecting " + String(self.expecting) + " packages"
    }
    
    @objc public func updatePackageFetchStatus() {
        self.expectingLabel.text = "\(self.totalRefreshedSoFar.count) out of \(self.packages.count) packages fetched..."
    }
    
    func refreshStatusOfAllPackages() {
        if self.packages.count == 0 {
            self.expectingLabel.text = "Expecting 0 packages"
            return
        }
        self.expecting = 0
        self.totalRefreshedSoFar = [String]()
        self.expectingLabel.text = "\(self.totalRefreshedSoFar.count) out of \(self.packages.count) packages fetched..."
        for package in self.packages {
            let trackingNum = package["tracking_number"] as! String
            self.statusForTrackingNum[trackingNum] = "Loading status..."
        }
        self.tableview.reloadData()
        
        DispatchQueue.main.async {
            for package in self.packages {
                let trackingNum = package["tracking_number"] as! String
                let carrier = package["carrier"] as! String
                
                self.sendRequest(trackingNum, carrier) { data in
                    self.statusForTrackingNum[trackingNum] = data
                    self.totalRefreshedSoFar.append(trackingNum)
                    print(self.totalRefreshedSoFar)
                    if (data.contains("Transit")) {
                        self.expecting = self.expecting + 1;
                        print(self.expecting)
                    }
                    if (self.totalRefreshedSoFar.count == self.packages.count) {
                        self.performSelector(onMainThread: #selector(self.updateExpectingPackages), with: nil, waitUntilDone: true)
                    } else {
                        self.performSelector(onMainThread: #selector(self.updatePackageFetchStatus), with: nil, waitUntilDone: true)
                    }
                    self.tableview.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PackageTableViewCell
        let cell = tableview.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for: indexPath) as! PackageTableViewCell
        
        self.trackingNum = packages[indexPath.row]["tracking_number"] as! String
        self.carrier = packages[indexPath.row]["carrier"] as! String
        cell.trackingNumberLabel.text = self.trackingNum
        cell.carrierLabel.text = self.carrier
        //cell.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7607843137, blue: 0.5568627451, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.05710693449, green: 0.1802713573, blue: 0.2454774082, alpha: 1)
        cell.statusLabel.text = self.statusForTrackingNum[self.trackingNum]
        cell.nameLabel.text = packages[indexPath.row]["name"] as? String
        
        if (self.statusForTrackingNum[self.trackingNum]!.contains("Transit") ){
            cell.statusImage.tintColor = UIColor.yellow
        } else if (self.statusForTrackingNum[self.trackingNum]!.contains("Delivered")) {
            cell.statusImage.tintColor = #colorLiteral(red: 0.03967227406, green: 0.6154822335, blue: 0.1182794488, alpha: 1)
        } else if (self.statusForTrackingNum[self.trackingNum]!.contains("Loading status...")){
            cell.statusImage.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        } else {
            cell.statusImage.tintColor = UIColor.red
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let cell = tableview.cellForRow(at: indexPath) as! PackageTableViewCell
        // print(cell.trackingNumber.text!)
        // self.present(TrackViewController, animated: true, completion: nil)
        let trackNum = packages[indexPath.row]["tracking_number"] as? String
        if !(self.totalRefreshedSoFar.contains(trackNum ?? "invalid")) {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "TrackViewController") as! UINavigationController
        let trackViewController = nav.topViewController as! TrackViewController
        let carrier = packages[indexPath.row]["carrier"] as? String
        trackViewController.setTrackingNumAndCarrier(trackNum, carrier)
        trackViewController.packageName = packages[indexPath.row]["name"] as! String
        nav.modalPresentationStyle = .fullScreen
        // self.navigationController?.pushViewController(newViewController, animated: true)
        // self.present(nav, animated: true)
        self.navigationController?.pushViewController(trackViewController, animated: true)
    }
    

    
    
    func sendRequest(_ trackingNum: String, _ carrier: String, completion: @escaping (String)->()) {
        var returnData = "Loading status..."
        let headers = [
            "content-type": "application/json",
            "x-rapidapi-key": "c6e12970f5msh258f9543aba75efp155d01jsn8923c7e612e6",
            "x-rapidapi-host": "order-tracking.p.rapidapi.com"
        ]
        let parameters = [
            "tracking_number": trackingNum,
            "carrier_code": carrier
        ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "https://order-tracking.p.rapidapi.com/trackings/realtime")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if (error != nil) {
                    print(error!)
                } else if let data = data {
                    let httpResponse = response as? HTTPURLResponse
                    // print(httpResponse)
                    // let trackingData = String(decoding: data!, as: UTF8.self)
                    // print(trackingData)
                    // if (trackingData != nil) {
                    //     returnValue = trackingData
                    // }
                    // print(data)
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    // print(dataDictionary)
                    let packageInfo = dataDictionary["data"] as! [String : Any]
                    // print(packageInfo)
                    if packageInfo["items"] == nil {
                        return completion("Package not found.")
                    }
                    let items = packageInfo["items"] as! [[String:Any]]
                    // print(items)
                    let lastEvent = items[0]["lastEvent"] as! String
                    if (lastEvent.count <= 0) {
                        return completion("Package not found.")
                    }
                    // print(lastEvent)
                    //let lastUpdateTime = items[0]["lastUpdateTime"] as! String
                    // print(lastUpdateTime)
                    let originInfo = items[0]["origin_info"] as! [String:Any]
                    // print(originInfo)
                    let trackInfo = originInfo["trackinfo"] as! [[String:Any]]
                    
                    // returnData = trackInfo[0]["checkpoint_status"] as! String
                    
                    let status = trackInfo[0]["checkpoint_status"] as! String
                    let time = trackInfo[0]["Date"]  as! String
                    
                    let dateFormatterGet1 = DateFormatter()
                    dateFormatterGet1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let dateFormatterGet2 = DateFormatter()
                    dateFormatterGet2.dateFormat = "yyyy-MM-dd HH:mm"

                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "MMM d, h:mm a"
                    
                    
                    var finaldate = Date()
                    if (dateFormatterGet1.date(from: time) != nil) {
                        finaldate = dateFormatterGet1.date(from: time)!
                    } else if (dateFormatterGet2.date(from: time) != nil) {
                        finaldate = dateFormatterGet2.date(from: time)!
                    } else {
                       print("There was an error decoding the string")
                    }
                    
                    returnData = "\(status.localizedCapitalized) \(dateFormatterPrint.string(from: finaldate))"
                    //returnData = "\(status.localizedCapitalized) \(finaldate)"
                    
                    // print(trackInfo)
                    // returnData = trackInfo
                    // returnData = lastEvent
                    // returnData["lastEvent"] = lastEvent
                    // returnData["lastUpdateTime"] = lastUpdateTime
                    // print(returnData)
                    
                    // print(self.statusForTrackingNum)
                    
                    return completion(returnData)
                }
            }).resume()
        } catch {
            print(error)
        }
    }
    
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //     if let nav = segue.destination as? UINavigationController, let trackViewController = nav.topViewController as? TrackViewController {
    //         trackViewController.setTrackingNumAndCarrier(trackNumInput.text, carrierInput.text)
    //     }
    // }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
