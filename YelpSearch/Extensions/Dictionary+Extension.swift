//
//  Dictionary+Extension.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

extension Dictionary
{
    func urlEncoded() -> String
    {
        var result: String = ""
        for (index, entry) in self.enumerated()
        {
            let key: String = "\(entry.key)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let value: String = "\(entry.value)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            result += (index == 0 ? "\(key)=\(value)" : "&\(key)=\(value)")
        }
        return result
    }
}
