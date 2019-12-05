//
//  Category.swift
//  testingRealm
//
//  Created by Nauman Bajwa on 12/2/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
