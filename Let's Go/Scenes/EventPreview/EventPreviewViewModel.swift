//
//  EventPreviewViewModel.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import RxSwift
import RxRelay
import Appwrite
import Foundation
import UIKit

typealias Registrations = [Registration]
typealias URLs = [URL]

protocol EventPreviewViewModelInputs {
    func goToDetailsButtonTapped()
}

protocol EventPreviewViewModelOutputs {
    var eventName: Observable<String>! { get }
    var numberOfParticipants: Observable<String>! { get }
    var eventCost: Observable<String>! { get }
    var eventDate: Observable<String>! { get }
    var eventDuration: Observable<String>! { get }
    var eventDescription: Observable<String>! { get }
    var eventImagesURLs: Observable<URLs>! { get }
}

protocol EventPreviewViewModelProtocol {
    var inputs: EventPreviewViewModelInputs { get }
    var outputs: EventPreviewViewModelOutputs { get }
}

final class EventPreviewViewModel: EventPreviewViewModelProtocol, EventPreviewViewModelOutputs {
    
    var inputs: EventPreviewViewModelInputs { self }
    var outputs: EventPreviewViewModelOutputs { self }
    
    var eventName: Observable<String>!
    var numberOfParticipants: Observable<String>!
    var eventCost: Observable<String>!
    var eventDate: Observable<String>!
    var eventDuration: Observable<String>!
    var eventDescription: Observable<String>!
    var eventImagesURLs: Observable<URLs>!

    private let sceneOutput: EventMapSceneOutput?
    private let eventValue: BehaviorSubject<Event>
            
    init(event: Event, sceneOutput: EventMapSceneOutput?) {
        self.sceneOutput = sceneOutput
        eventValue = BehaviorSubject(value: event)
        
        eventName = eventValue
            .map { event in
                event.event ?? Strings.event_without_name
            }
        
        let numberOfRegiteredUsers = eventValue
            .flatMap { [unowned self] event in
                createRegistrationLoadingEvent(event)
            }
        
        numberOfParticipants = Observable.combineLatest(numberOfRegiteredUsers, eventValue)
            .map { registrations, event in
                if let numberOfParticipants = event.userCount {
                    return Strings.participants_of_total(num: registrations.count, of: numberOfParticipants)
                } else {
                    return Strings.num_participants(num: registrations.count)
                }
            }
        
        eventCost = eventValue
            .map { event in
                if let cost = event.cost {
                    return "\(Strings.participation_cost) \(cost)\(Strings.RUB)"
                } else {
                    return "\(Strings.participation_cost) - \(Strings.unknown)"
                }
            }
        
        eventDate = eventValue
            .map { event in
                if let dateMls = event.toDate {
                    let date = Date(timeIntervalSince1970mls: dateMls)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .short
                    return "\(Strings.date) \(dateFormatter.string(from: date))"
                } else {
                    return "\(Strings.date) - \(Strings.unknown)"
                }
            }
        
        eventDuration = eventValue
            .map { event in
                if let duration = event.duration {
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.hour, .minute]
                    formatter.unitsStyle = .short
                    return "\(Strings.will_last) \(formatter.string(from: .init(second: duration / 1000)) ?? Strings.unknown)"
                } else {
                    return "\(Strings.will_last) - \(Strings.unknown)"
                }
            }
        
        eventImagesURLs = eventValue
            .map { event in
                return event.photosURL
            }
        
        eventDescription = eventValue
            .compactMap(\.desc)
        
    }
    
    private func createRegistrationLoadingEvent(_ event: Event) -> Observable<Registrations> {
        Observable.create { observer in
            let task = Task {
                do {
                    let session = try await Databases.shared.getItems(Registration.self, from: .registrations, queries: [Query.equal(Registration.CodingKeys.status.rawValue, value: ["creator", "go"]), Query.equal(Registration.CodingKeys.markID.rawValue, value: event.id)])
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

extension EventPreviewViewModel: EventPreviewViewModelInputs {
    func goToDetailsButtonTapped() {
        guard let event = try? eventValue.value() else { return }
        sceneOutput?.showEventPage(event)
    }
}
