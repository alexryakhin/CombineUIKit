//
//  UIViewX.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Foundation
import UIKit

class UIViewX: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        addSubviews()
    }
    func addSubviews() { }
    
    func showView(with duration: TimeInterval = 0.2) {
        
        self.isHidden = false
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
        }
    }
    
    func hideView(with duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] isFinished in
            if isFinished {
                self?.isHidden = true
            }
        }
    }
}
