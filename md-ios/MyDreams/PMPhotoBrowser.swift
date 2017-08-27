//
//  PMPhotoBrowser.swift
//  MyDreams
//
//  Created by Иван Ушаков on 02.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

import UIKit
import SKPhotoBrowser

open class PMPhotoBrowser: SKPhotoBrowser {
    
    override open func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override open func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
}
