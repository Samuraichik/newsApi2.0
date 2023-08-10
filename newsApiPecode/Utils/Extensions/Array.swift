//
//  Array.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

let categoriesArray = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
let countriesArray = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz",
                        "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma",
                        "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk",
                        "th", "tr", "tw", "ua", "us", "ve", "za"]
let sourcesArray = ["BBC News", "The New York Times", "CNN", "Washington Post", "CNBC", "TIME", "Euronews", "The Washington Times"]
