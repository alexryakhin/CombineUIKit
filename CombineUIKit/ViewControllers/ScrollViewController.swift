//
//  ScrollViewController.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import UIKit
import Combine

final class ScrollViewController: UIViewControllerX {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    let viewModel = ScrollViewModel()
    let textField1 = UITextField()
    let textField2 = UITextField()
    let label1 = UILabel()
    let label2 = UILabel()
    let stackView = UIStackView()
    
    var scrollViewBottomContraint: NSLayoutConstraint!
    let inset: CGFloat = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        needToHideNavBar = false
        view.backgroundColor = .white
        setupView()
        setupBinding()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(textField1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(textField2)
        
        scrollView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.leftRightOffset)
            make.trailing.bottom.equalToSuperview().offset(-Constants.leftRightOffset)
            make.width.equalToSuperview().offset(-(Constants.leftRightOffset * 2))
        }
    }
    
    private func setupView() {
        addSubviews()
        setupScrollView()
        setupStackView()
        setupLabel1()
        setupLabel2()
        setupTextField1()
        setupTextField2()
    }
    
    private func setupScrollView() {
        scrollViewBottomContraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomContraint.isActive = true
        scrollViewBottomContraint.constant = inset
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
    }
    
    private func setupLabel1() {
        label1.text = "With a background in reactive programming in UIKit with RxSwift and RxCocoa, I was intrigued to see if Combine could be used in a similar manner to that which I’m already accustomed to in the world of RxSwift. I’ve seen some confusion over how Combine should be used with UIKit, so let’s explore some possibilities."
        label1.numberOfLines = 0
        label1.sizeToFit()
    }
    
    private func setupLabel2() {
        label2.text = "Whilst Combine can be used with UIKit, it doesn’t provide publishers for controls like text fields, search bars, buttons etc. So we cannot get out of the box, a stream of text entered into a search bar from which to create our input. This is something RxSwift developers are used to in the guise of RxCocoa. Combine was clearly engineered for SwiftUI and this is where Apple are pushing everything, so I’d be surprised if we see further UIKit integration in future.\n\nWe can however create publishers for these controls ourselves, and there’s a couple of options. The easy way is to use subjects in our view controllers, and imperatively send events to these subjects. Checkout this post for a nice solution using this technique. The harder way is to create new publishers ourselves. You can see a great example here. For the purposes of a quick demo, I’m going to take the middle road and use CombineCocoa to provide these publishers for me, whilst also keeping everything reactive (with no imperative code in the view controller)."
        label2.numberOfLines = 0
        label2.sizeToFit()
    }
    
    private func setupTextField1() {
        textField1.placeholder = "Enter text"
        textField1.borderStyle = .roundedRect
    }
    
    private func setupTextField2() {
        textField2.placeholder = "Enter text"
        textField2.borderStyle = .roundedRect
    }
    
    private func setupBinding() {
        UIResponder.keyboardPublisher().sink { [unowned self] state in
            if state.state == .willShow, let view = [textField1, textField2].first(where: { $0.isFirstResponder }) {
                if view.frame.maxY > state.frame.minY {
                    let offset = CGPoint(x: 0, y: scrollView.frame.height - state.frame.height + inset * 2)
                    scrollView.setContentOffset(offset, animated: true)
                }
            }
            let offset = (state.isVisible) ? state.frame.height : 0
            scrollViewBottomContraint.constant = -offset
        }.store(in: &cancellable)
    }
}
