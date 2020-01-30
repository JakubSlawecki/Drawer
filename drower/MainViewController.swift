//
//  ViewController.swift
//  drower
//
//  Created by Jakub Slawecki on 29/01/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var drawerView: DrawerView!
    @IBOutlet weak var drawerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDrawerView()
    }
    
    private func setupDrawerView() {
        drawerView.panRecognizer.delegate = self
        drawerView.delegate = self
        
        drawerHeightConstraint.constant = drawerView.drawerViewSize
        drawerBottomConstraint.constant = drawerView.popupOffset
    }
    
}

extension MainViewController: DrawerViewDelegate {
    func drawerViewOpeaningAnimation() {
        self.drawerBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func drawerViewClosingAnimation() {
        self.drawerBottomConstraint.constant = self.drawerView.popupOffset
        self.view.layoutIfNeeded()
    }
    
}
