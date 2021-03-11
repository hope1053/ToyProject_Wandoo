//
//  LectureInfo.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/28.
//

import UIKit

struct LectureInfo {
    let name: String
    let date: String
    let numoflec: Int
    
    init(name:String, date:String, numoflec: Int) {
        self.name = name
        self.date = date
        self.numoflec = numoflec
    }
}
