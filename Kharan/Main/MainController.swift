//
//  MainController.swift
//  Kharan
//
//  Created by Edson Rottava Júnior on 16/07/19.
//  Copyright © 2019 Edson Rottava Júnior. All rights reserved.
//

import UIKit
import SpriteKit

class MainController: UIViewController {
    var currentScreen: screen = screen.initial
    var currentView: UIView = UIView()
    
    override func loadView() {
        super.loadView()
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        prepareView()
    }
    
}

extension MainController {
    
    @objc func prepareView(){
        switch (currentScreen) {
        case .initial:
            setupSplashView()
            currentScreen = .splash
            break
        case .splash:
            clearView()
            setupTitleView()
            currentScreen = .title
            break
        case .title:
            clearView()
            setupGameView()
            currentScreen = .game
            break
        case .game:
            setupTitleView()
            currentScreen = .title
            break
        }
    }
    
    private func setupGameView() {
        let skView: SKView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        let scene = MainScene(size: view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.viewController = self
        let transition = SKTransition.reveal(with: .down, duration: 1.0)
        skView.presentScene(scene, transition: transition)
    }
    
    private func clearView() {
        while let subview = view.subviews.last {
            subview.removeFromSuperview()
        }
    }
}

extension MainController {
    //Enum
    enum screen {
        case initial
        case splash
        case title
        case game
    }
}
