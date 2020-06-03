//
//  CustomProgessBar.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/25/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit

class CustomProgessBar: UIProgressView {
     //override customUIButtom
     override init(frame:CGRect) {
         super.init(frame:frame)
         setupButton()
     }
      //initialize button for storyboard
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         setupButton()
     }
     
    //setup BUtton to set up configuration for button
     func setupButton() {
       transform = transform.scaledBy(x: 1, y: 5)

         
     }
    
}
