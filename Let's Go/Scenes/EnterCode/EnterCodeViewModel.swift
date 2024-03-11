//
//  EnterCodeViewModel.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import Foundation

protocol EnterCodeViewModelInputs {
    
}

protocol EnterCodeViewModelOutputs {
}

protocol EnterCodeViewModelProtocol {
    var inputs: EnterCodeViewModelInputs { get }
    var outputs: EnterCodeViewModelOutputs { get }
}

final class EnterCodeViewModel: EnterCodeViewModelProtocol, EnterCodeViewModelOutputs, EnterCodeViewModelInputs {
    // MARK: - Public Properties
    var inputs: EnterCodeViewModelInputs { self }
    var outputs: EnterCodeViewModelOutputs { self }
    // MARK: - Private Properties
    private let sceneOutput: LoginSceneOutput?
    // MARK: - Init
    init(sceneOutput: LoginSceneOutput?) { 
        self.sceneOutput = sceneOutput
    }
}
