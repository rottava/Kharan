//
//  MainController.swift
//  Kharan
//
//  Created by Edson Rottava Júnior on 16/07/19.
//  Copyright © 2019 Edson Rottava Júnior. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class MainController: UIViewController {
    var currentScreen: screen = screen.initial
    var currentView: UIView = UIView()
    private var audioPlayer = AVAudioPlayer()
    private var bgSound = NSURL(fileURLWithPath:Bundle.main.path(forResource: "Title", ofType: "wav")!)
    
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
            playSound()
            currentScreen = .title
            break
        case .title:
            clearView()
            setupGameView()
            audioPlayer.pause()
            currentScreen = .game
            break
        case .game:
            setupTitleView()
            audioPlayer.play()
            currentScreen = .title
            break
        }
    }
    
    func setupGameView() {
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
    
    private func playSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: bgSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting File")
        }
        audioPlayer.play()
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
