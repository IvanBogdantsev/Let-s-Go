//
//  MapViewModel.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 22.09.2023.
//

import RxSwift
import RxRelay
import Appwrite
import YandexMapsMobile

typealias Placemarks = [Placemark]

protocol MapViewModelInputs {
    func boundingBoxUpdated(_ boundingBox: YMKBoundingBox)
}

protocol MapViewModelOutputs {
    var placemarks: Observable<Placemarks>! { get }
}

protocol MapViewModelProtocol {
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
}

final class MapViewModel: MapViewModelProtocol, MapViewModelOutputs {
    
    var inputs: MapViewModelInputs { self }
    var outputs: MapViewModelOutputs { self }
    
    var placemarks: Observable<Placemarks>!
    
    private let boundingBoxValue = PublishRelay<YMKBoundingBox>()
    
    init() {
        let queries = boundingBoxValue
            .map { boundingBox in
                [
                    Query.limit(100),
                    Query.greaterThan(Placemark.CodingKeys.toDate.rawValue, value: Date().timeIntervalSince1970mls),
                    Query.lessThanEqual(attribute: Placemark.CodingKeys.latitude.rawValue, value: boundingBox.northEast.latitude),
                    Query.greaterThanEqual(Placemark.CodingKeys.latitude.rawValue, value: boundingBox.southWest.latitude),
                    Query.lessThanEqual(attribute: Placemark.CodingKeys.longitude.rawValue, value: boundingBox.northEast.longitude),
                    Query.greaterThanEqual(Placemark.CodingKeys.longitude.rawValue, value: boundingBox.southWest.longitude)
                ]
            }
        
        self.placemarks = queries
            .flatMap { [unowned self] queries in
                self.createPlacemarkLoadingEvent(queries)
            }
    }
    
    private func createPlacemarkLoadingEvent(_ queries: [String]? = nil) -> Observable<Placemarks> {
        Observable.create { observer in
            let task = Task {
                do {
                    let session = try await Databases.shared.getItems(Placemark.self, queries: queries)
                    observer.on(.next(session))
                    observer.on(.completed)
                } catch {
                    observer.on(.error(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}

extension MapViewModel: MapViewModelInputs {
    func boundingBoxUpdated(_ boundingBox: YMKBoundingBox) {
        boundingBoxValue.accept(boundingBox)
    }
}
