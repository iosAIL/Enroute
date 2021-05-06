//
//  PackageCell.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/9/21.
//

import UIKit

extension UIView {
    func addDashedBorder() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 5
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [10,5]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 3, y: 0),
                                CGPoint(x: 3, y: self.frame.height)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

class RouteCell: UITableViewCell {
    @IBOutlet weak var statusDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var details: UILabel!
    // @IBOutlet weak var checkpointStatus: UILabel!
    @IBOutlet weak var checkpointStatus: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    // @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
