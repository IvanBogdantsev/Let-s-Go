//
//  MapViewController.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 22.09.2023.
//

import UIKit
import RxSwift
import YandexMapsMobile
import CoreLocation

final class EventMapViewController: UIViewController {
    
    private let eventMapView = EventMapView()
    private let viewModel: EventMapViewModelProtocol
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
        
    init(viewModel: EventMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        eventMapView.map.addCameraListener(with: self)
        eventMapView.map.setMapLoadedListenerWith(self)
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        eventMapView.map.mapObjects.addTapListener(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = eventMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModel()
    }
    
    private func addTargets() {}
    
    private func bindViewModel() {
        self.viewModel.outputs.events
            .observeOnMainThread()
            .subscribe(onNext: { [weak self] events in
                self?.eventMapView.addEvents(events)
            }, onError: { [weak self] message in
                print(message.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}

extension EventMapViewController: YMKMapCameraListener,  YMKMapLoadedListener {
    func onMapLoaded(with statistics: YMKMapLoadStatistics) {
        guard let boundingBox = createCurrentBoundingBox() else { return }
        viewModel.inputs.boundingBoxUpdated(boundingBox)
    }
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        guard finished, let boundingBox = createCurrentBoundingBox() else { return }
        viewModel.inputs.boundingBoxUpdated(boundingBox)
    }
    
    func createCurrentBoundingBox() -> YMKBoundingBox? {
        guard let northEast = eventMapView.mapView.mapWindow.screenToWorld(with: YMKScreenPoint(
            x: Float(eventMapView.mapView.mapWindow.width()), y: 0)),
              let southWest = eventMapView.mapView.mapWindow.screenToWorld(with: YMKScreenPoint(
                x: 0, y: Float(eventMapView.mapView.mapWindow.height())))
        else { return nil }
        return YMKBoundingBox(southWest: southWest, northEast: northEast)
    }
}

extension EventMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        eventMapView.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 12, azimuth: 0, tilt: 0), animation: YMKAnimation(type: .smooth, duration: Float(AnimationDuration.macroRegular.timeInterval)))
        manager.stopUpdatingLocation()
    }
}

extension EventMapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        return true
    }
}
