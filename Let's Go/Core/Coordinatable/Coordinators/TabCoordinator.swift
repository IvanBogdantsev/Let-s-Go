//
//  TabCoordinator.swift
//  FlightGuide
//
//  Created by Ivan B on 16.05.23.
//

import UIKit

protocol TabCoordinatorInterface: Coordinatable {
    func selectPage(_ page: TabCoordinator.TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabCoordinator.TabBarPage?
}

protocol TabCoordinatorDelegate: AnyObject {
    func didLogoutUser(_ coordinator: TabCoordinator)
}

final class TabCoordinator: BaseCoordinator {
    
    enum TabBarPage: Int, CaseIterable {
        case map
        case favorites
        case chat
        case profile

        fileprivate var tabBarItem: UITabBarItem {
            switch self {
            case .map:
                return UITabBarItem(
                    title: Strings.map.capitalized,
                    image: Images.map_fill,
                    selectedImage: Images.map_fill
                )
            case .favorites:
                return UITabBarItem(
                    title: Strings.favorites.capitalized,
                    image: Images.star_fill,
                    selectedImage: Images.star_fill
                )
            case .chat:
                return UITabBarItem(
                    title: Strings.chat.capitalized,
                    image: Images.message_fill,
                    selectedImage: Images.message_fill
                )
            case .profile:
                return UITabBarItem(
                    title: Strings.profile.capitalized,
                    image: Images.person_fill,
                    selectedImage: Images.person_fill
                )
            }
        }
    }

    private let navigationController: UINavigationController
    private let tabBarController: UITabBarController

    weak var delegate: TabCoordinatorDelegate?

    required init(
        navigationController: BaseNavigationController,
        delegate: TabCoordinatorDelegate?
    ) {
        self.delegate = delegate
        self.navigationController = navigationController
        tabBarController = UITabBarController()
        super.init(router: Router(rootController: navigationController))
        startingViewController = tabBarController
        setupAppearance()
    }

    override func start() {
        let controllers: [UINavigationController] = TabBarPage.allCases.map({ getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
        UIView.transition(
            with: self.navigationController.view,
            duration: AnimationDuration.macroRegular.timeInterval,
            options: .transitionCrossDissolve,
            animations: {
                self.router.setRootModule(self.tabBarController)
            },
            completion: nil
        )
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.allCases.first?.rawValue ?? 0
    }
    
    private func setupAppearance() {
        tabBarController.tabBar.backgroundColor = Colors.letsgo_main_gray
        tabBarController.tabBar.tintColor = Colors.letsgo_main_red
        tabBarController.tabBar.isTranslucent = true
        navigationController.isNavigationBarHidden = true
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = BaseNavigationController()
        navigationController.tabBarItem = page.tabBarItem
        
        let router = Router(rootController: navigationController)

        switch page {
        case .map:
            let mapCoordinator = MapCoordinator(router: router)
            mapCoordinator.parent = self
            children.append(mapCoordinator)
            mapCoordinator.start()
        case .favorites:
            let vc = RemoveThisShitViewController()
            vc.onExiButtonClick = { [weak self] in
                self?.delegate?.didLogoutUser(self!)
            }
            navigationController.viewControllers = [vc]
        case .chat:
            let vc = RemoveThisShitViewController()
            vc.onExiButtonClick = { [weak self] in
                self?.delegate?.didLogoutUser(self!)
            }
            navigationController.viewControllers = [vc]
        case .profile:
            let vc = RemoveThisShitViewController()
            vc.onExiButtonClick = { [weak self] in
                self?.delegate?.didLogoutUser(self!)
            }
            navigationController.viewControllers = [vc]
        }
        return navigationController
    }
    
}

extension TabCoordinator: TabCoordinatorInterface {
    func currentPage() -> TabBarPage? {
        TabBarPage(rawValue: tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.rawValue
    }

    func setSelectedIndex(_ index: Int) {
        tabBarController.selectedIndex = index
    }
}







//TODO: Remove after demo

class RemoveThisShitViewController: UIViewController {
    
    var onExiButtonClick: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let label = UILabel()
        let button = UIButton()
        label.font = .letsgo_body()
        label.textColor = Colors.letsgo_main_red
        label.textAlignment = .center
        label.text = "Здесь пока ничего нет, \n но ты можешь"
        label.numberOfLines = 0
        
        button.defaultStyleBoldedRed()
        button.setTitle("Выйти", for: .normal)
        
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        view.addSubviews(label, button)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).inset(-10)
            $0.width.equalTo(label)
        }
        
    }
    
    @objc func logout() {
        onExiButtonClick?()
    }
    
}
