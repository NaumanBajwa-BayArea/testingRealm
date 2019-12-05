//
//  Item.swift
//  testingRealm
//
//  Created by Nauman Bajwa on 12/2/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
  @objc dynamic var title : String = ""
  @objc dynamic  var done  : Bool   = false
    var partentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
