//
//  EventPreviewViewController.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit
import RxSwift
import Nuke

final class EventPreviewViewController: UIViewController {
    
    private let eventPreviewView = EventPreviewView()
    private let viewModel: EventPreviewViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: EventPreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
        sheetPresentationController?.prefersGrabberVisible = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = eventPreviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetPresentationController?.detents = [.custom { _ in 250 }, .medium()]
    }
    
    private func addTargets() {
        eventPreviewView.detailsButton.addTarget(
            self,
            action: #selector(goToDetailsButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        viewModel.outputs.eventName
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPreviewView.eventTitleLabel.text = text
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
                self?.eventPreviewView.numberOfParticipantsLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventCost
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPreviewView.costLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventDate
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPreviewView.dateLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventDuration
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPreviewView.durationLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.eventDescription
            .observeOnMainThread()
            .subscribe { [weak self] text in
                self?.eventPreviewView.descriptionLabel.text = text
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
            eventPreviewView.horizontalViewScroller.insertImages(images.isEmpty ? [Images.default_event_pic] : images)
        }
    }
    
}

extension EventPreviewViewController {
    @objc func goToDetailsButtonTapped() {
        viewModel.inputs.goToDetailsButtonTapped()
    }
}
