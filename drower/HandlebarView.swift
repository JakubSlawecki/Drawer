//
//  HandlebarView.swift
//  drower
//
//  Created by Jakub Slawecki on 30/01/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import UIKit

class HandlebarView: UIView {

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.cornerRadius = 3
    }

}
