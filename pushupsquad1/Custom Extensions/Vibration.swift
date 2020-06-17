//
//  Vibration.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 6/9/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import Foundation
import UIKit

class Vibrator {
    
    class func light() {

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
    }
    class func medium() {

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
    }
    class func heavy() {

        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
    }
    class func success() {

       UINotificationFeedbackGenerator().notificationOccurred(.success)
        
    }
    class func error() {

       UINotificationFeedbackGenerator().notificationOccurred(.error)
        
    }



}





