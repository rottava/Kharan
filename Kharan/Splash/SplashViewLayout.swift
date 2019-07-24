//
//  SplashViewLayout.swift
//  Kharan
//
//  Created by Edson Rottava Júnior on 16/07/19.
//  Copyright © 2019 Edson Rottava Júnior. All rights reserved.
//

import UIKit

// MARK: - Layout
extension MainController {

    func setupSplashView() {
        prepareSplashView()
        prepareSplashTitleLabel()
    }
    
    private func prepareSplashView() {
        let splashView = UIImageView()
        splashView.image = UIImage(named: "Background")
        splashView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(splashView)
        //Constraints
        splashView.translatesAutoresizingMaskIntoConstraints = false
        splashView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        splashView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        splashView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        splashView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func prepareSplashTitleLabel() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text  = "KHARAN"
            label.textColor = UIColor.blue
            label.font = UIFont(name: "Zing Rust Demo Base", size: 60)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: view.bounds.height / 4).isActive = true
    }
    
}
