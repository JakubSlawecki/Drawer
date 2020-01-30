//
//  DrawerView.swift
//  drower
//
//  Created by Jakub Slawecki on 29/01/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import UIKit

// MARK: State of the DrawerView
enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open:
            return .closed
        case .closed:
            return .open
        }
    }
}

protocol DrawerViewDelegate: AnyObject {
    func drawerViewOpeaningAnimation()
    func drawerViewClosingAnimation()
}

class DrawerView: GradientView, UIGestureRecognizerDelegate {
    
    /// This value indicates how much the DrawerView should stick out over the edge in its **open** state,
    /// so this value tells its height.
    ///
    /// ### Usage Example: ###
    /// ````
    /// DrawerView.drawerViewSize = UIScreen.main.bounds.height * 0.8
    /// or
    /// DrawerView.drawerViewSize = 400
    /// ````
    /// * in the first example, Drawer will have a height of 80% of the screen height
    /// * in the second example, Drawer will have a height of 400
    var drawerViewSize = UIScreen.main.bounds.height * 0.8
    
    /// This value indicates how much the DrawerView should stick out over the edge in its **closed** state
    ///
    /// ## Important Notes ##
    /// 0 means that DrawerView is completely hidden, the higher the value, the more it will stick out
    var drawerViewOffset: CGFloat = 100
    
    private var runningAnimators  = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    private var currentState: State = .closed
    
    weak var delegate: DrawerViewDelegate?
    
    var popupOffset: CGFloat = 0
    
    lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
    }
    
    private func setupUI () {
        popupOffset = -drawerViewSize + drawerViewOffset
        
        addGestureRecognizer(panRecognizer)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.cornerRadius = 25
        self.shadowColor = UIColor.black
        self.shadowOffset = CGSize(width: 0, height: -1.8)
        self.shadowRadius = 2.2
        self.shadowOpacity = 0.08

        self.topColor = UIColor.white
        self.bottomColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        let dampingView = UIView()
        
        self.addSubview(dampingView)
        dampingView.translatesAutoresizingMaskIntoConstraints = false
        dampingView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dampingView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dampingView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dampingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dampingView.backgroundColor = self.bottomColor
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.6)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
        case .changed:
            let translation = recognizer.translation(in: self)
            var fraction = translation.y / popupOffset
            
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            let yVelocity = recognizer.velocity(in: self).y
            let shouldClose = yVelocity > 0
            
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if  shouldClose &&  runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if  shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose &&  runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            ()
        }
    }
    
    func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }
        let timingParameters = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 1))
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        transitionAnimator.addAnimations {
            switch state {
                //opeaningAnimation / closingAnimation
            case .open:
                self.delegate?.drawerViewOpeaningAnimation()
            case .closed:
                self.delegate?.drawerViewClosingAnimation()
            }
        }
        //MARK: Animator #1

        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            switch self.currentState {
            case .open:
                self.delegate?.drawerViewOpeaningAnimation()
            case .closed:
                self.delegate?.drawerViewClosingAnimation()
            }
            self.runningAnimators.removeAll()
        }
        
        //MARK: start all animators
        transitionAnimator.startAnimation()
        
        //MARK: keep track of all running animators
        runningAnimators.append(transitionAnimator)
        
    }
}
