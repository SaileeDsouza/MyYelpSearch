//
//  SearchCollectionViewCell.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(restaurantModel: RestaurantModel) {
        nameLabel.text = restaurantModel.name
        addressLabel.text = restaurantModel.displayAddress?.joined(separator: ", ")
    }
}

extension UINib {
    static let SearchCollectionViewCell = UINib(nibName: "SearchCollectionViewCell", bundle: .main)
}
