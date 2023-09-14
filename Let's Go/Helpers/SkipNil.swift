//
//  SkipNil.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 01.09.2023.
//

import RxSwift

extension ObservableType {
    func skipNil<Result>() -> Observable<Result> where Element == Result? {
        self.compactMap { $0 }
    }
}

