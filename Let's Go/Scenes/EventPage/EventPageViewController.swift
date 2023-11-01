//
//  EventPageViewController.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit
import RxSwift
import Nuke

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
    
    private func bindViewModel() {
        viewModel.outputs.eventName
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPageView.eventTitleLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventImagesURLs
            .subscribe { [weak self] urls in
                self?.loadImages(urls)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.numberOfParticipants
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPageView.numberOfParticipantsLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventCost
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPageView.costLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventDate
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPageView.dateLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventDuration
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPageView.durationLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventDescription
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPageView.descriptionLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.creator
            .observeOnMainThread()
            .subscribe { [weak self] creator in
                self?.eventPageView.creatorView.setWithUser(creator)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.participants
            .observeOnMainThread()
            .subscribe { [weak self] users in
                guard let self else { return }
                let views = self.loadUsers(users)
                eventPageView.participantsScroller.insertViews(views)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.activeUsers
            .observeOnMainThread()
            .subscribe { [weak self] users in
                guard let self else { return }
                let views = self.loadUsers(users)
                eventPageView.activeUsersScroller.insertViews(views)
            }
            .disposed(by: disposeBag)
    }
    
    private func loadImages(_ urls: [URL]) {
        var images: [UIImage?] = []
        Task {
            for url in urls {
                let image = try? await ImagePipeline.shared.image(for: url)
                images.append(image)
            }
            eventPageView.eventImagesScroller.insertImages(images.isEmpty ? [Images.default_event_pic] : images)
        }
    }
    
    private func loadUsers(_ users: Users) -> [UserPreview] {
        return users.map { user in
            let userPreview = UserPreview()
            userPreview.setWithUser(user)
            return userPreview
        }
    }
    
}
