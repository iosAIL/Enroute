//
//  PackageTableViewCell.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/17/21.
//

import UIKit

class PackageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    /*override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let trackingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Tracking number not found."
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let carrierLabel: UILabel = {
        let label = UILabel()
        label.text = "Carrier not found."
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Untitled"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading status..."
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        let cellView = UIView()
        addSubview(cellView)
        cellView.backgroundColor = UIColor.white
        cellView.layer.cornerRadius = 10
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(carrierLabel)
        cellView.addSubview(trackingNumberLabel)
        cellView.addSubview(nameLabel)
        cellView.addSubview(statusLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        // dayLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        // dayLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        // dayLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        carrierLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        carrierLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        trackingNumberLabel.topAnchor.constraint(equalTo: carrierLabel.topAnchor).isActive = true
        trackingNumberLabel.leftAnchor.constraint(equalTo: carrierLabel.rightAnchor, constant: 10).isActive = true
        statusLabel.topAnchor.constraint(equalTo: carrierLabel.bottomAnchor, constant: 10).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: 20).isActive = true
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.numberOfLines = 0
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

