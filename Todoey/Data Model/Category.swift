//
//  Category.swift
//  Todoey
//
//  Created by michael kibler on 5/14/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
