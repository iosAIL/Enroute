//
//  TextInputTableViewCell.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 5/12/21.
//

import UIKit

class TextInputTableViewCell: UITableViewCell {
    @IBOutlet weak var textfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
