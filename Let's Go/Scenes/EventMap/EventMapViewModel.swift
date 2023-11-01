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

typealias Events = [Event]

protocol EventMapViewModelInputs {
    func boundingBoxUpdated(_ boundingBox: YMKBoundingBox)
    func eventSelected(_ event: Event)
}

protocol EventMapViewModelOutputs {
    var events: Observable<Events>! { get }
}

protocol EventMapViewModelProtocol {
    var inputs: EventMapViewModelInputs { get }
    var outputs: EventMapViewModelOutputs { get }
}

final class EventMapViewModel: EventMapViewModelProtocol, EventMapViewModelOutputs {
    
    var inputs: EventMapViewModelInputs { self }
    var outputs: EventMapViewModelOutputs { self }
    
    var events: Observable<Events>!
    
    private let boundingBoxValue = PublishRelay<YMKBoundingBox>()
    
    private let sceneOutput: EventMapSceneOutput?
    
    init(sceneOutput: EventMapSceneOutput?) {
        self.sceneOutput = sceneOutput
        
        let queries = boundingBoxValue
            .map { boundingBox in
                [
                    Query.limit(100),
                   // Query.greaterThan(Event.CodingKeys.toDate.rawValue, value: Date().timeIntervalSince1970mls),
                    Query.lessThanEqual(attribute: Event.CodingKeys.latitude.rawValue, value: boundingBox.northEast.latitude),
                    Query.greaterThanEqual(Event.CodingKeys.latitude.rawValue, value: boundingBox.southWest.latitude),
                    Query.lessThanEqual(attribute: Event.CodingKeys.longitude.rawValue, value: boundingBox.northEast.longitude),
                    Query.greaterThanEqual(Event.CodingKeys.longitude.rawValue, value: boundingBox.southWest.longitude)
                ]
            }
        
        self.events = queries
            .flatMap { [unowned self] queries in
                createEventLoadingEvent(queries)
            }
    }
    
    private func createEventLoadingEvent(_ queries: [String]? = nil) -> Observable<Events> {
        Observable.create { observer in
            let task = Task {
                do {
                    let session = try await Databases.shared.getItems(Event.self, from: .marks, queries: queries)
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

extension EventMapViewModel: EventMapViewModelInputs {
    func boundingBoxUpdated(_ boundingBox: YMKBoundingBox) {
        boundingBoxValue.accept(boundingBox)
    }
    
    func eventSelected(_ event: Event) {
        sceneOutput?.showEventPreview(event)
    }
}
