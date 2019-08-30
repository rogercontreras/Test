//
//  PlaceItemTableViewCell.swift
//  ArkusnexusTest
//
//  Created by Rogelio Contreras Velázquez on 28/08/19.
//  Copyright © 2019 Rogelio Contreras Velázquez. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class PlaceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel1: UILabel!
    @IBOutlet weak var addressLabel2: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var rateControl: CosmosView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var petIcon: UIImageView!
    @IBOutlet weak var petFriendlyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with place : Place) {
        self.titleLabel.text = place.placeName
        self.addressLabel1.text = place.addressLine1
        self.addressLabel2.text = place.addressLine2
        self.rateControl.rating = place.rating
        self.rateControl.settings.fillMode = .precise
        print("place rating: \(place.rating)")

        self.placeImageView.sd_setImage(with: place.thumbnail, placeholderImage: UIImage(named: ""))
        self.placeImageView.layer.cornerRadius = 8
        self.placeImageView.layer.masksToBounds = true
        
        self.petIcon.isHidden = !place.isPetFriendly
        self.petFriendlyLabel.isHidden = !place.isPetFriendly
        
        if let distance = place.distance {
            self.distanceLabel.text = String(format: "%.1f km", distance/1000)
        }
    }
    
}
