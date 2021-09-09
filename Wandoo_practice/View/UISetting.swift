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

let buttonColorForDarkMode: UIColor = {
    if #available(iOS 13, *) {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                // Return color for Dark Mode
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                // Return color for Light Mode
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    } else {
        // Return fallback color for iOS 12 and lower
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}()
