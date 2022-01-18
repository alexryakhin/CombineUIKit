//
//  AlertView.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Foundation
import UIKit

final class AlertView: UIViewX {
    // MARK: - Private properties
    private var imageView: UIImageView!
    private var title: UILabel!
    private var subtitle: UILabel!
    private var blueButton: UIButton!
    private var closeButton: UIButton!
    private let blackView = UIView()
    
    // MARK: - Public methods
    override func setupView() {
        super.setupView()
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        setupImage()
        setupTitle()
        setupSubtitle()
        setupButton()
        setupCloseButton()
        addShadow()
    }
    
    func configure(image: UIImage?, title: String, subtitle: String, blueButtonTitle: String) {
        self.blueButton.setTitle(blueButtonTitle, for: .normal)
        self.imageView.image = image
        self.title.text = title
        self.subtitle.text = subtitle
    }
    
    func blueButtonClicked(action: @escaping (() -> Void)) {
        blueButton.onClick { [unowned self] in
            dismiss()
            action()
        }
    }
    
    func closeButtonClicked(action: @escaping (() -> Void)) {
        closeButton.onClick { [unowned self] in
            dismiss()
            action()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.alpha = 0
            blackView.alpha = 0
        } completion: { [unowned self] isFinished in
            if isFinished {
                blackView.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    
    func add(on view: UIView) {
        blackView.backgroundColor = .black.withAlphaComponent(0.7)
        self.alpha = 0
        blackView.alpha = 0
        view.addSubview(blackView)
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.leftRightOffset)
            make.centerX.centerY.equalToSuperview()
        }
        blackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.alpha = 1
            blackView.alpha = 1
        }
    }
    
    // MARK: - Private methods
    private func setupImage() {
        self.imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupTitle() {
        self.title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .black
        title.textAlignment = .center
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupSubtitle() {
        self.subtitle = UILabel()
        subtitle.textColor = .black
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        subtitle.lineBreakMode = .byWordWrapping
        self.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(Constants.leftRightOffset)
            make.trailing.equalToSuperview().offset(-Constants.leftRightOffset)
        }
    }
    
    private func setupButton() {
        self.blueButton = UIButton()
        blueButton.setBackgroundColor(.blue, forState: .normal)
        blueButton.setBackgroundColor(.blue.withAlphaComponent(0.7), forState: .highlighted)
        blueButton.setTitleColor(.white, for: .normal)
        blueButton.titleLabel?.font = .systemFont(ofSize: 14)
        blueButton.layer.cornerRadius = 8
        blueButton.clipsToBounds = true
        
        self.addSubview(blueButton)
        blueButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.leftRightOffset)
            make.trailing.equalToSuperview().offset(-Constants.leftRightOffset)
            make.height.equalTo(48)
            make.top.equalTo(subtitle.snp.bottom).offset(24)
        }
    }
    
    private func setupCloseButton() {
        closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.setTitleColor(.black.withAlphaComponent(0.7), for: .highlighted)
        closeButton.titleLabel?.font = .systemFont(ofSize: 14)
        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.leftRightOffset)
            make.trailing.equalToSuperview().offset(-Constants.leftRightOffset)
            make.height.equalTo(48)
            make.top.equalTo(blueButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
