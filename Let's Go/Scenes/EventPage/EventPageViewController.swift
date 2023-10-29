//
//  EventPageViewController.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit
import RxSwift

final class EventPageViewController: UIViewController {
    
    private let eventPageView = EventPageView()
    private let viewModel: EventPageViewModelProtocol
    private let disposeBag = DisposeBag()
        
    init(viewModel: EventPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = eventPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModel()
    }
    
    private func addTargets() {}
    
    private func bindViewModel() {}
    
}
