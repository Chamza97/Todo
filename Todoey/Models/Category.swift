//
//  Category.swift
//  Todoey
//
//  Created by admin on 16/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic    var name: String = ""
   let items = List<Item>()
}
