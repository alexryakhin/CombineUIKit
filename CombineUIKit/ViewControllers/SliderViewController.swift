//
//  SliderViewController.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import UIKit
import Combine

final class SliderViewController: UIViewControllerX {
    
    let viewModel = SliderViewModel()
    var cancellable = Set<AnyCancellable>()
    let slider = UISlider()
    let clearButton = UIButtonX()
    let labelForText = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupView()
        setupConnections()
        needToHideNavBar = false
    }
    
    func setupConnections() {
        slider
            .createBinding(with: viewModel.currentSliderValue, storeIn: &cancellable)
        
        viewModel.currentSliderValue
//            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: true)
            .map { value in
                return "number: \(value)"
            }
            .assign(to: \.text, on: labelForText)
            .store(in: &cancellable)
        
        clearButton
            .tapPublisher()
            .sink { [unowned self] _ in
                viewModel.currentSliderValue.send(0)
            }
            .store(in: &cancellable)
    }
    
    func setupView() {
        view.backgroundColor = .white
        setupClearButton()
        setupLabel()
    }
    
    func addSubviews() {
        [clearButton, slider, labelForText].forEach({ view.addSubview($0) })
        clearButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        slider.snp.makeConstraints { make in
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
        clearButton.setTitle("Set to zero", for: .normal)
        clearButton.setTitleColor(.tintColor, for: .normal)
        clearButton.setTitleColor(.blue, for: .highlighted)
    }
    
    func setupLabel() {
        labelForText.text = "text"
        labelForText.font = .systemFont(ofSize: 20)
        labelForText.textColor = .red
        labelForText.numberOfLines = 0
    }
}
