//
//  MainViewLayout.swift
//  Kharan
//
//  Created by Edson Rottava Júnior on 16/07/19.
//  Copyright © 2019 Edson Rottava Júnior. All rights reserved.
//

import UIKit

// MARK: - Layout
extension MainViewController {
    
    func setupLayout() {
        prepareView()
        prepareTitleLabel()
        preparePlayLabel()
    }
    
    private func prepareView() {
        view.removeFromSuperview()
        view.addSubview(mainView)
        //Constraints
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
    }
    
    private func prepareTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: view.bounds.height / 4).isActive = true
        
    }
    
    private func preparePlayLabel() {
        view.addSubview(playLabel)
        playLabel.translatesAutoresizingMaskIntoConstraints = false
        playLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.bounds.height / 3).isActive = true
    }
}
