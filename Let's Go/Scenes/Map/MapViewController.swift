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

final class MapViewController: UIViewController {
    
    private let mapView = MapView()
    private let viewModel: MapViewModelProtocol
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
        
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mapView.map.addCameraListener(with: self)
        mapView.map.setMapLoadedListenerWith(self)
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModel()
    }
    
    private func addTargets() {}
    
    private func bindViewModel() {
        self.viewModel.outputs.placemarks
            .observeOnMainThread()
            .subscribe(onNext: { [weak self] placemarks in
                self?.mapView.addPlacemarks(placemarks)
            }, onError: { [weak self] message in
                print(message.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}

extension MapViewController: YMKMapCameraListener,  YMKMapLoadedListener {
    func onMapLoaded(with statistics: YMKMapLoadStatistics) {
        guard let boundingBox = createCurrentBoundingBox() else { return }
        viewModel.inputs.boundingBoxUpdated(boundingBox)
    }
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        guard finished, let boundingBox = createCurrentBoundingBox() else { return }
        viewModel.inputs.boundingBoxUpdated(boundingBox)
    }
    
    func createCurrentBoundingBox() -> YMKBoundingBox? {
        guard let northEast = mapView.mapView.mapWindow.screenToWorld(with: YMKScreenPoint(
            x: Float(mapView.mapView.mapWindow.width()), y: 0)),
              let southWest = mapView.mapView.mapWindow.screenToWorld(with: YMKScreenPoint(
                x: 0, y: Float(mapView.mapView.mapWindow.height())))
        else { return nil }
        return YMKBoundingBox(southWest: southWest, northEast: northEast)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        mapView.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 12, azimuth: 0, tilt: 0), animation: YMKAnimation(type: .smooth, duration: Float(AnimationDuration.macroRegular.timeInterval)))
        manager.stopUpdatingLocation()
    }
}
