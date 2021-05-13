//
//  DropdownTableViewCell.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 5/12/21.
//

import UIKit
import AYPopupPickerView

class DropdownTableViewCell: UITableViewCell {
    let singleComponetPopupPickerView = AYPopupPickerView()
    @IBOutlet weak var carrierLabel: UILabel!
    var selectedIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        addGestureRecognizer(touchGesture)
    }
    
    @objc func gestureAction() {
        superview?.endEditing(true)
        let itemsTitle = ["FedEx", "UPS", "USPS"]
        self.singleComponetPopupPickerView.display(itemTitles: itemsTitle, defaultIndex: selectedIndex, doneHandler: {
            let newIndex = self.singleComponetPopupPickerView.pickerView.selectedRow(inComponent: 0)
            self.selectedIndex = newIndex
            self.carrierLabel.text = itemsTitle[newIndex]
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
