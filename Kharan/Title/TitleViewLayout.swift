//
//  TitleViewLayout.swift
//  Kharan
//
//  Created by Edson Rottava Júnior on 16/07/19.
//  Copyright © 2019 Edson Rottava Júnior. All rights reserved.
//

import UIKit

// MARK: - Layout
extension MainController {

    func setupTitleView() {
        prepareTitleView()
        prepareTitleLabel()
    }

    private func prepareTitleView() {
        let titleView = UIImageView()
        titleView.image = UIImage(named: "Background")
        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        //titleView.loadGif(name: "Background")
        view.addSubview(titleView)
        //Constraints
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        titleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func prepareTitleLabel() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text  = "KHARAN"
            label.textColor = UIColor.blue
            label.font = UIFont(name: "Zing Rust Demo Base", size: 64)
            //label.shadowColor = UIColor.black
            //label.shadowOffset = CGSize(width: 1, height: 2)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: view.bounds.height / 4).isActive = true
        
        let playLabel: UILabel = {
            let label = UILabel()
            label.text  = "Touch to start"
            label.textAlignment = .center
            return label
        }()
        view.addSubview(playLabel)
        playLabel.translatesAutoresizingMaskIntoConstraints = false
        playLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.bounds.height / 3).isActive = true
        fadeLabel(view: playLabel, delay: 0)
        
        let playButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(prepareView), for: .touchUpInside)
            return button
        }()
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        playButton.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        playButton.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
    }
    
    private func fadeLabel(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.75
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            UIView.animate(withDuration: animationDuration, delay: delay, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }
}
