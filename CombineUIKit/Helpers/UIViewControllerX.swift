//
//  UIViewControllerX.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Foundation
import UIKit

class UIViewControllerX: UIViewController {
    
    // MARK: - Keyboard binding
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
    }()
    var window: UIWindow {
        UIApplication.shared.windows[0]
    }

    // MARK: - Public properties
    var needToHideNavBar: Bool = true
    var needShowCloseButton: Bool = false
    
    weak var alertController: UIAlertController?
    weak var dimView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        navigationController?.setNavigationBarHidden(needToHideNavBar, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(needToHideNavBar, animated: animated)
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationDidBecomeActive() {
        
    }
    
    @objc func applicationWillResignActive() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    func setBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func onCloseButtonPressed() { }
    
    @objc func onMenuButtonPressed() { }
    
    @objc func menuButtonTapped() { }
    
    @objc func menuButtonUntapped() { }
    
    func handleKeyboardDidShown(_ keyboardBounds: CGRect) { }
    
    func handleKeyboardDidHidden(_ keyboardBounds: CGRect) { }
}

// Errors
extension UIViewControllerX {
    func handleError(_ error: NSError, handler: ((Int) -> Void)? = nil) {
        let message = error.userInfo["message"] as? String ?? "unknown error"
        showAlert(message: message, buttons: ["ОК"], cancelButtonIndex: 1, handler: handler)
    }
    
    func showAlert(title: String = "",
                   message: String,
                   buttons: [String] = [],
                   cancelButtonIndex: Int = 0,
                   handler: ((Int) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.view.tintColor = .black
        if !buttons.isEmpty {
            for i in 0 ..< buttons.count {
                let action = UIAlertAction(title: buttons[i], style: i == cancelButtonIndex ? .cancel : .default) { _ in
                    handler?(i)
                }
                alertController.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
// MARK: - HUD
extension UIViewControllerX {
    func showDimView(with color: UIColor) {
        if let dimView = self.dimView {
            if !view.subviews.contains(dimView) {
                view.addSubview(dimView)
            }
        } else {
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = color
            dimView.alpha = 0
            view.addSubview(dimView)
            self.dimView = dimView
            UIView.animate(withDuration: 0.5, animations: {
                dimView.alpha = 1
            })
        }
    }
    
    func hideDimView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView?.alpha = 0
        })
        dimView?.removeFromSuperview()
        dimView = nil
    }
    
    func showAlert(on parent: UIView, alertType type: AlertType, blueButtonAction: @escaping (() -> Void), closeButtonAction: (() -> Void)? = nil) {
        let alert = AlertView(frame: .zero)
        alert.configure(
            image: type.image,
            title: type.title,
            subtitle: type.subTitle,
            blueButtonTitle: type.blueButtonText)
        alert.blueButtonClicked(action: blueButtonAction)
        alert.closeButtonClicked { closeButtonAction?() }
        alert.add(on: parent)
    }
}

enum AlertType {
    case heart
    case contacts
    
    var image: UIImage? {
        switch self {
        case.heart:
            return UIImage(systemName: "heart")
        case .contacts:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .heart:
            return "Title"
        case .contacts:
            return "Title"
        }
    }
    
    var subTitle: String {
        switch self {
        case .heart:
            return "Subtitle"
        case .contacts:
            return "Subtitle"
        }
    }
    
    var blueButtonText: String {
        switch self {
        case .heart:
            return "Like"
        case .contacts:
            return "Yes"
        }
    }
}

extension UIViewControllerX {
    func addTapRecognizerToHideKeyboard(_ target: UIView? = nil) {
        let target = target ?? view
        target?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func removeTapRecognizerToHideKeyboard(_ target: UIView? = nil) {
        let target = target ?? view
        target?.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    func subscribeToKeyboardNotifications() {
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardShown))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardHidden))
    }
    
    private func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        window.endEditing(true)
    }
    
    @objc
    private func keyboardShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else { return }
        addTapRecognizerToHideKeyboard()
        
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        handleKeyboardDidShown(endRect)
    }
    
    @objc
    private func keyboardHidden(notification: NSNotification) {
        guard  let userInfo = notification.userInfo,
               let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else { return }
        removeTapRecognizerToHideKeyboard()
        
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        handleKeyboardDidHidden(endRect)
        
    }
}
