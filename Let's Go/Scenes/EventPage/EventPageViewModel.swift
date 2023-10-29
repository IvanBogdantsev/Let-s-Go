//
//  EventPageViewModel.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import RxSwift
import RxRelay

protocol EventPageViewModelInputs {
}

protocol EventPageViewModelOutputs {
    
}

protocol EventPageViewModelProtocol {
    var inputs: EventPageViewModelInputs { get }
    var outputs: EventPageViewModelOutputs { get }
}

final class EventPageViewModel: EventPageViewModelProtocol, EventPageViewModelOutputs {
    
    var inputs: EventPageViewModelInputs { self }
    var outputs: EventPageViewModelOutputs { self }
            
    private let sceneOutput: EventMapSceneOutput?
    private let eventValue: Observable<Event>
            
    init(event: Event, sceneOutput: EventMapSceneOutput?) {
        self.sceneOutput = sceneOutput
        eventValue = BehaviorSubject(value: event)
        
    }
    
}

extension EventPageViewModel: EventPageViewModelInputs {

}
