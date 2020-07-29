//
//  UIViewController+Activity.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation
import UIKit

var activityView: UIView?

extension UIViewController {
    
    func showActivityIndicator(onView : UIView) {
        let spinnerView: UIView = UIView(frame: CGRect(x: (onView.frame.size.width / 2.0) - 50, y: (onView.frame.size.height / 2.0) - 50, width: 100, height: 100))
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 35, y: 35, width: 30, height: 30))
        spinnerView.backgroundColor = UIColor.white
        spinnerView.layer.cornerRadius = 5.0
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.black
        activityIndicator.tintColor = UIColor.black
        activityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }
        activityView = spinnerView
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            activityView?.removeFromSuperview()
            activityView = nil
        }
    }
    
    //to show Alert message to user
    func showAlertMessage(message: String) {
        let alert: UIAlertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
