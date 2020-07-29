//
//  ApplicationServices.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

protocol ApplicationServiceDelegate: AnyObject {
    func getBusinessService() -> BusinessService!
}

class ApplicationServices: ApplicationServiceDelegate  {
    
    private(set) var businessService: BusinessService!
    
    init() {
        businessService = BusinessManager.shared
    }
    
    func getBusinessService() -> BusinessService! {
        return businessService
    }
    
}
