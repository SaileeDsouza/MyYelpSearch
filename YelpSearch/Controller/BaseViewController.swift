//
//  BaseViewController.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-28.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK:- Properties
    private(set) var applicationServices : ApplicationServices = (UIApplication.shared.delegate as! AppDelegate).applicationServices
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
