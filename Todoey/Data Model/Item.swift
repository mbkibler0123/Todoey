//
//  Item.swift
//  Todoey
//
//  Created by michael kibler on 5/14/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
