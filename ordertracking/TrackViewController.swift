//
//  ViewController.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/8/21.
//

import UIKit
import Foundation

class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var trackInfo = [[String:Any]]()
    var trackingNum = "";
    var packageName = "";
    var carrier = "";
    
    func setTrackingNumAndCarrier(_ trackNum: String?, _ carrier: String?) {
        self.trackingNum = trackNum!
        self.carrier = carrier!
    }
    
    func sendRequest(completion: @escaping ([[String:Any]])->()) {
        var returnData = [[String:Any]]()
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
                    print(data)
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print(dataDictionary)
                    let packageInfo = dataDictionary["data"] as! [String : Any]
                    print(packageInfo)
                    if packageInfo["items"] == nil {
                        return completion([])
                    }
                    let items = packageInfo["items"] as! [[String:Any]]
                    // print(items)
                    let lastEvent = items[0]["lastEvent"] as! String
                    if (lastEvent.count <= 0) {
                        return completion([])
                    }
                    // print(lastEvent)
                    let lastUpdateTime = items[0]["lastUpdateTime"] as! String
                    // print(lastUpdateTime)
                    let originInfo = items[0]["origin_info"] as! [String:Any]
                    // print(originInfo)
                    let trackInfo = originInfo["trackinfo"] as! [[String:Any]]
                        
                    // print(trackInfo)
                    returnData = trackInfo
                    // returnData["lastEvent"] = lastEvent
                    // returnData["lastUpdateTime"] = lastUpdateTime
                    // print(returnData)
                    return completion(returnData)
                }
            }).resume()
        } catch {
            print(error)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        // self.title = "Tracking Number: \(trackingNum)"
        self.title = "Loading..."
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        // DispatchQueue.main.async {
        //     print(returnData)
        // }
        // print(getTrackingData())
        // print(self.trackingData)
        // label.text = self.trackingData["lastEvent"] as? String
        
        
        // let trackingData = getTrackingData()
        // if trackingData != nil{
        //     label.text = trackingData
        // }
        sendRequest() { data in
            DispatchQueue.main.async {
                print(data)
                if (data.count <= 0) {
                    self.title = "No package found."
                    return
                }
                self.trackInfo = data;
                self.tableView.reloadData()
                self.title = self.packageName
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func close(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCell") as! RouteCell
        
        let locations = trackInfo[indexPath.row]
        let statusDescription = locations["StatusDescription"] as! String
        let date = locations["Date"] as! String
        let details = locations["Details"] as! String
        let checkpointStatus = locations["checkpoint_status"] as! String
        // cell.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        let dateFormatterGet1 = DateFormatter()
        dateFormatterGet1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterGet2 = DateFormatter()
        dateFormatterGet2.dateFormat = "yyyy-MM-dd HH:mm"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"
        
        var finaldate = Date()
        if (dateFormatterGet1.date(from: date) != nil) {
            finaldate = dateFormatterGet1.date(from: date)!
        } else if (dateFormatterGet2.date(from: date) != nil) {
            finaldate = dateFormatterGet2.date(from: date)!
        } else {
           print("There was an error decoding the string")
        }
        
        let datefinal = dateFormatterPrint.string(from: finaldate)
        
        if !statusDescription.isEmpty {
            cell.statusDescription.text = statusDescription
        }
        if !date.isEmpty {
            cell.date.text = datefinal
        }
        if !details.isEmpty {
            cell.details.text = details
        }
        if !checkpointStatus.isEmpty {
            cell.checkpointStatus.text = checkpointStatus
            if (checkpointStatus == "transit" || checkpointStatus == "pending" || checkpointStatus == "pickup"){
                cell.arrow.tintColor = UIColor.yellow
            } else if (checkpointStatus == "delivered") {
                cell.arrow.tintColor = #colorLiteral(red: 0.03967227406, green: 0.6154822335, blue: 0.1182794488, alpha: 1)
            } else {
                cell.arrow.tintColor = UIColor.red
            }
        }
        
        cell.orderNum.text = String(trackInfo.count - indexPath.row)
        return cell
    }
}
