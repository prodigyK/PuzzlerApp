//
//  PickerData.swift
//  Puzze15App
//
//  Created by Konstantin Petkov on 08.08.2020.
//  Copyright © 2020 Konstantin Petkov. All rights reserved.
//

import Foundation

class PickerData {
    
    static func getPickerData() -> [String] {
        
        var pickerArray = [String]()
        
        
        pickerArray.append("Small 3 x 3")
        pickerArray.append("Classic 4 x 4")
        pickerArray.append("Big 5 x 5")
        pickerArray.append("Huge 6 x 6")
        
        return pickerArray
    }
}
