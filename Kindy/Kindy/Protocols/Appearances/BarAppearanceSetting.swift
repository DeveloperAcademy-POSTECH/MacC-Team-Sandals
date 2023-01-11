import UIKit

/// 탭 바의 appearance를 불투명한 흰색으로 설정.
protocol TabBarAppearanceSetting: UIViewController { }

/// 내비게이션 바의 appearance를 불투명한 흰색으로 설정.
protocol NavBarAppearanceSetting: UIViewController { }

/// 탭 바, 네비게이션 바의 appearance를 불투명한 흰색으로 설정.
protocol BarAppearanceSetting: TabBarAppearanceSetting, NavBarAppearanceSetting { }

extension TabBarAppearanceSetting {
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

extension NavBarAppearanceSetting {
    func configureNavBarAppearance(title: String = "") {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white

        navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
    }
}
