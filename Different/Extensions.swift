//
//  Extensions.swift
//  Different
//
//  Created by nonplus on 3/4/21.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1.0)
    }
    
    static func randomColorSet(numberOfColors: Int) -> [UIColor] {
        var set = Set<UIColor>()
        while set.count < numberOfColors {
            set.insert(random)
        }
        return Array(set)
    }

}
