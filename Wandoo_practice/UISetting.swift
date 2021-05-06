//
//  UISetting.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/05/04.
//

import Foundation
import UIKit

class UIRoundButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 9
    }
}
