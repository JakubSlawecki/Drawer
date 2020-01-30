
//
//  File.swift
//  drower
//
//  Created by Jakub Slawecki on 29/01/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import UIKit

class GradientView: UIView {
    var shadowView : UIView = UIView()
    var cardView : UIView = UIView()
    var gradientLayer : CAGradientLayer = CAGradientLayer()
    var handlebar: HandlebarView = HandlebarView()
    
    var topColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }
    
    var bottomColor: UIColor = .black {
        didSet {
            updateGradientColors()
        }
    }
    
    var shadowOpacity : Float = 0.0 {
        didSet {
           shadowView.layer.shadowOpacity = shadowOpacity
        }
    }
        
    var shadowRadius : CGFloat = 0.0 {
        didSet {
            shadowView.layer.shadowRadius = shadowRadius
        }
    }
        
    var shadowColor : UIColor? {
        didSet {
            shadowView.layer.shadowColor = shadowColor?.cgColor
        }
    }
        
    var shadowOffset : CGSize = .zero {
        didSet {
            shadowView.layer.shadowOffset = shadowOffset
        }
    }
    
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            cardView.layer.cornerRadius = cornerRadius
            cardView.layer.cornerRadius = CGFloat(cornerRadius)
            cardView.clipsToBounds = true
            cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            shadowView.layer.cornerRadius = cornerRadius
        }
    }
    
    private func setup() {
        self.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shadowView.backgroundColor = UIColor.black
            
        self.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cardView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardView.backgroundColor = UIColor.black
        
        self.addSubview(handlebar)
        handlebar.translatesAutoresizingMaskIntoConstraints = false
        handlebar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        handlebar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handlebar.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        handlebar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
           
        self.sendSubviewToBack(handlebar)
        self.sendSubviewToBack(cardView)
        self.sendSubviewToBack(shadowView)
            
        cardView.clipsToBounds = true
        cardView.layer.insertSublayer(gradientLayer, at: 0)
            
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = cardView.bounds
        
        updateGradientColors()
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            gradientLayer.locations = [0.0, 0.5]
        } else {
            gradientLayer.locations = [0.0, 0.5]
        }
        
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
}
