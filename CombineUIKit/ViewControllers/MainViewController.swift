//
//  ViewController.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import UIKit
import Combine
import SnapKit

final class MainViewController: UIViewControllerX {
    
    let viewModel = MainViewModel()
    var cancellable = Set<AnyCancellable>()
    let textField = UITextField()
    let clearButton = UIButtonX()
    let labelForText = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupView()
        setupConnections()
        needToHideNavBar = false
    }
    
    private func setupConnections() {
        // MARK: two consumers for the publisher
        // so by that - every time when publisher has new value, it'll update text label
        // that is one data stream
        viewModel.textSubject
            .sink { [unowned self] value in
                self.labelForText.text = value
            }
            .store(in: &cancellable) // cancellable will be dealoccated when vc's gone
        
        // then data stream to the text field
        viewModel.textSubject
            .sink { [unowned self] value in
                self.textField.text = value
            }
            .store(in: &cancellable)
        
        // MARK: update publisher's value
        // then text field should send its new value each time
        textField
            .textPublisher()
            .sink { [unowned self] newValue in
                self.viewModel.textSubject.send(newValue)
            }
            .store(in: &cancellable)
        
        // button action, which updates publisher's value as well
        // button sends nothing, just registers a tap
        clearButton
            .tapPublisher()
            .sink { [unowned self] _ in
                self.viewModel.textSubject.send("")
            }
            .store(in: &cancellable)
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
        textField.borderStyle = .roundedRect
    }
    
    func setupLabel() {
        labelForText.text = "text"
        labelForText.font = .systemFont(ofSize: 20)
        labelForText.textColor = .red
        labelForText.numberOfLines = 0
    }
    
    deinit {
        print("deinit MainVC")
    }
    
}

