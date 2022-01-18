//
//  UIButtonX.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Foundation
import UIKit

class UIButtonX: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
            x: self.bounds.origin.x - 10,
            y: self.bounds.origin.y - 10,
            width: self.bounds.size.width + 20,
            height: self.bounds.size.height + 20
        )
        return newArea.contains(point)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
}
