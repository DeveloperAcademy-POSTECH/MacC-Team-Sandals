//
//  AppearanceDelegate.swift
//  Kindy
//
//  Created by 정호윤 on 2022/12/02.
//

import UIKit

protocol BarAppearanceDelegate: TabBarAppearanceDelegate, NavBarAppearanceDelegate { }
protocol TabBarAppearanceDelegate: UIViewController { }
protocol NavBarAppearanceDelegate: UIViewController { }

extension TabBarAppearanceDelegate {
    func configureTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = .white

            tabBarController?.tabBar.standardAppearance = tabBarAppearance
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
}

extension NavBarAppearanceDelegate {
    func configureNavBarAppearance(title: String) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
    }
}
