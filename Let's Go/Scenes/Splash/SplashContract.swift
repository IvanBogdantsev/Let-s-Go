//
//  SplashContract.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation

protocol SplashViewInterface: AnyObject,
                              DisplayLoaderInterface {
}

protocol SplashViewModelInterface: AnyObject {
    func viewDidLoad()
}

protocol SplashSceneOutput: AnyObject {
    func proceedFromSplash()
}
