//
//  ViewController.swift
//  drower
//
//  Created by Jakub Slawecki on 29/01/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var drawerView: DrawerView!
    @IBOutlet weak var drawerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerBottomConstraint: NSLayoutConstraint!
    
    // This value determines how visible SlideView is in close state
    let drawerViewOffset: CGFloat = 100
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDrawerView()
    }
    
    private func setupDrawerView() {
        
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        // This value determines how visible SlideView is in open state
        let drawerViewSize = screenSize.height * 0.8
        
        drawerView.panRecognizer.delegate = self
        drawerView.delegate = self
        drawerView.popupOffset = drawerViewSize - drawerViewOffset
        drawerHeightConstraint.constant = drawerViewSize
        drawerBottomConstraint.constant = drawerView.popupOffset
    }
    
}

extension MainViewController: UIGestureRecognizerDelegate {
    
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
    
    func didFinichOpeaningDrawerView() {
        self.drawerBottomConstraint.constant = 0
        
        self.view.layoutIfNeeded()
    }
    
    func didFinishClosingDrawerView() {
        self.drawerBottomConstraint.constant = self.drawerView.popupOffset
        
        self.view.layoutIfNeeded()
    }
    
    
}

