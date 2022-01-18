//
//  ViewController.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import UIKit
import SnapKit

class MainViewController: UIViewControllerX {
    
    let textField = UITextField()
    let clearButton = UIButtonX()
    let labelForText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        setupClearButton()
        setupTextField()
        setupLabel()
    }
    
    func addSubviews() {
        [clearButton, textField, labelForText].forEach({ view.addSubview($0) })
        clearButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.leftRightOffset)
            make.trailing.equalToSuperview().offset(-Constants.leftRightOffset)
            make.height.equalTo(32)
            make.bottom.equalTo(clearButton.snp.top).offset(-Constants.leftRightOffset)
        }
        labelForText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clearButton.snp.bottom).offset(Constants.leftRightOffset)
        }
    }
    
    func setupClearButton() {
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        clearButton.setTitleColor(.tintColor, for: .normal)
        clearButton.setTitleColor(.blue, for: .highlighted)
    }
    
    func setupTextField() {
        textField.borderStyle = .bezel
    }
    
    func setupLabel() {
        labelForText.text = "text"
        labelForText.font = .systemFont(ofSize: 20)
        labelForText.textColor = .red
    }
    
}

