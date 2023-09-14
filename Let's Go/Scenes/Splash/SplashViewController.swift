//
//  SplashViewController.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import UIKit

final class SplashViewController: UIViewController {

    private let logo = UIImageView(image: Images.logo_white)
    private var viewModel: SplashViewModelInterface
    
    init(viewModel: SplashViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .letsgo_main_gray
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        logo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(50)
        }
        viewModel.viewDidLoad()
    }
}
