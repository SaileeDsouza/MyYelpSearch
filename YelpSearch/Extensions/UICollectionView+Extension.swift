//
//  UICollectionView+Extension.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-29.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.black
        messageLabel.font = UIFont.systemFont(ofSize: 18.0)
        emptyView.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: 0).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 30).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -30).isActive = true
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
