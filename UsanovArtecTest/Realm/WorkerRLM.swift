//
//  WorkerRLM.swift
//  UsanovArtecTest
//
//  Created by Алексей Усанов on 23/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import RealmSwift

class WorkerRLM: Object {
    @objc dynamic var name: String? = nil
    @objc dynamic var secondName: String? = nil
    @objc dynamic var salary: Int = 0
}
