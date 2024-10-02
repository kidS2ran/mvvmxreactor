//
//  DemoViewModel.swift
//  MVVMReactor
//
//  Created by Son Pham on 02/10/2024.
//

import Foundation
import RxRelay
import Then

class DemoViewModel: BaseMVVMReactorVM{
    
    var state     = BehaviorRelay<State>(value : .init())
    var action    = PublishRelay<Action>()
    var mutation  = PublishRelay<Mutation>()
    var navigator = PublishRelay<Navigation>()
    
    func mutate(action: Action, with state: State) {
        switch action {
        case .getData:
            break
        }
    }
    
    func reduce(previousState: State, mutation: Mutation) -> State? {
        switch mutation {
        case .setLoading(let loading):
            return previousState.with {
                $0.isLoading = loading
            }
        }
    }
}

extension DemoViewModel{
    struct State: Then {
        var isLoading: Bool = false
    }
    
    enum Action: Then {
        case getData
    }
    
    enum Mutation: Then {
        case setLoading(loading: Bool)
    }
    
    enum Navigation: Then {
        case showError(error: String)
    }
}
