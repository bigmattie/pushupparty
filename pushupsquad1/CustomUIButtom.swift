//
//  CustomUIButtom.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/25/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    
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
//        backgroundColor = UIColor.systemGreen
        layer.cornerRadius = 10
        layer.opacity = 0.95
        titleLabel?.font =  UIFont(name: "System Semibold", size: 22)


        
                
        
    }

    
}
