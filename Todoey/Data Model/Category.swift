//
//  Category.swift
//  Todoey
//
//  Created by Mackley Magalhães da Silva on 05/10/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    
    let items = List<Item>()
}
