//
//  EventPageViewModel.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import RxSwift
import RxRelay
import Foundation
import Appwrite

typealias Users = [User]

protocol EventPageViewModelInputs {
}

protocol EventPageViewModelOutputs {
    var eventName: Observable<String>! { get }
    var numberOfParticipants: Observable<String>! { get }
    var eventCost: Observable<String>! { get }
    var eventDate: Observable<String>! { get }
    var eventDuration: Observable<String>! { get }
    var eventDescription: Observable<String>! { get }
    var eventImagesURLs: Observable<URLs>! { get }
    var creator: Observable<User>! { get }
    var participants: Observable<Users>! { get }
    var activeUsers: Observable<Users>! { get }
}

protocol EventPageViewModelProtocol {
    var inputs: EventPageViewModelInputs { get }
    var outputs: EventPageViewModelOutputs { get }
}

final class EventPageViewModel: EventPageViewModelProtocol, EventPageViewModelOutputs {
    
    var inputs: EventPageViewModelInputs { self }
    var outputs: EventPageViewModelOutputs { self }
    
    var eventName: Observable<String>!
    var numberOfParticipants: Observable<String>!
    var eventCost: Observable<String>!
    var eventDate: Observable<String>!
    var eventDuration: Observable<String>!
    var eventDescription: Observable<String>!
    var eventImagesURLs: Observable<URLs>!
    var creator: Observable<User>!
    var participants: Observable<Users>!
    var activeUsers: Observable<Users>!

    private let sceneOutput: EventMapSceneOutput?
    private let eventValue: BehaviorSubject<Event>
            
    init(event: Event, sceneOutput: EventMapSceneOutput?) {
        self.sceneOutput = sceneOutput
        eventValue = BehaviorSubject(value: event)
        
        eventName = eventValue
            .map { event in
                event.event ?? Strings.event_without_name
            }
        
        let registrations = eventValue
            .flatMap { [unowned self] event in
                createRegistrationLoadingEvent(event)
            }
            .share()
        
        numberOfParticipants = Observable.combineLatest(registrations, eventValue)
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
        
        creator = registrations
            .compactMap { registrations in
                return registrations.filter { $0.status == "creator" }.first
            }
            .flatMap { [unowned self] registration in
                return createUserLoadingEvent(registration.userID)
            }
        
        participants = registrations
            .map { [unowned self] registrations in
                return registrations.filter { $0.status == "go" || $0.status == "creator" }
                    .map { createUserLoadingEvent($0.userID) }
            }
            .flatMap { observables in
                return Observable.combineLatest(observables)
            }
        
        activeUsers = registrations
            .map { [unowned self] registrations in
                return registrations.filter { $0.status == "active" || $0.status == "creator" }
                    .map { createUserLoadingEvent($0.userID) }
            }
            .flatMap { observables in
                return Observable.combineLatest(observables)
            }
        
    }
    
    private func createRegistrationLoadingEvent(_ event: Event) -> Observable<Registrations> {
        Observable.create { observer in
            let task = Task {
                do {
                    let session = try await Databases.shared.getItems(Registration.self, from: .registrations, queries: [Query.equal(Registration.CodingKeys.status.rawValue, value: ["creator", "go", "active"]), Query.equal(Registration.CodingKeys.markID.rawValue, value: event.id)])
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
    
    private func createUserLoadingEvent(_ userID: String) -> Observable<User> {
        Observable.create { observer in
            let task = Task {
                do {
                    let session = try await Databases.shared.getItem(User.self, from: .users, itemId: userID)
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

extension EventPageViewModel: EventPageViewModelInputs {

}
