//
//  TabBarViewController.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //three screens
        let vc1 = MainViewController()
        let vc2 = SliderViewController()
        let vc3 = ScrollViewController()
        let vc4 = ListViewController()
        
        //titles
        vc1.title = "UITextField"
        vc2.title = "UISlider"
        vc3.title = "UIScrollView"
        vc4.title = "List"
        
        //large titles
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        
        //three navigation controllers
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        //TabBarItems
        nav1.tabBarItem = UITabBarItem(title: "TextField", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Slider", image: UIImage(systemName: "slider.horizontal.3"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "ScrollView", image: UIImage(systemName: "scroll"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "doc.plaintext"), tag: 4)
        
        //large titles in nav bars
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: false)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBar.scrollEdgeAppearance = appearance
            tabBar.standardAppearance = appearance
        }
    }
}
