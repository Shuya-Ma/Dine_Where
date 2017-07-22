//
//  dinerInfo.swift
//  qr
//
//  Created by Shuya Ma on 12/6/16.
//  Copyright © 2016 Shuya Ma. All rights reserved.
//

import Foundation

struct DinerInfo {
    var DinerId: Int
    var Name: String
    var checkinImage: String
    var checkinBool: Bool
    
    
    init(DinerId: Int, Name: String, checkinImage: String){
        self.DinerId = DinerId
        self.Name = Name
        self.checkinImage = checkinImage
        self.checkinBool = false
    }
}
