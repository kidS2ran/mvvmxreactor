//
//  BaseMVVMReactorVM.swift
//  MVVMReactor
//
//  Created by Son Pham on 02/10/2024.
//

import Foundation
import RxSwift
import RxRelay

/// Based on ReactorKit (https://github.com/ReactorKit/ReactorKit)
///
/// Usage: conform your VM to this protocol and call `.setupFlow(disposeBag:)` in the `init` method or viewDidload in VC.
///
/// Main components:
///  - `state`: The current state of the View (used to display the UI)
///  - `action`: Actions performed by the view
///  - `mutation`: Not to be used in the View. Mutations (transformations) of the view (listened to in the `func mutate(action: Action, with state: State)` function)
///
/// MVVM Data Flow:
///  1. View -> Action -> mutation -> Model
///     - `action` -> bind/subscribe -> `mutate(action: Action, with state: State)` -> `mutation`
///
///  2. Model -> ViewModel -> View
///     - `mutation` -> accept -> `reduce(previousState: State, mutation: Mutation) -> State?` -> `state`
///
///  3. The View listens to the state via subscribe to update the UI
///

public
protocol BaseMVVMReactorVM: AnyObject {
    
    associatedtype State
    associatedtype Action
    associatedtype Mutation
    
    var state    : BehaviorRelay<State>   { get }
    var action   : PublishRelay<Action>   { get }
    var mutation : PublishRelay<Mutation> { get }
    
    func mutate(action: Action, with state: State)
    
    /// This is a pure function, reduce to new State.
    /// DON'T MAKE SIDE EFFECT HERE
    func reduce(previousState: State, mutation: Mutation) -> State?
}


public
extension BaseMVVMReactorVM {
    /// Function to construct the MVVM data flow between the `state`, `action`, and `mutation` variables
    func setupFlow(disposeBag: DisposeBag) {
        action
            .withLatestFrom(state, resultSelector: { (action, state) -> (Action, State) in
                return (action, state)
            })
            .subscribe(onNext: { [weak self] (action, state) in
                self?.mutate(action: action, with: state)
            })
            .disposed(by: disposeBag)
        
        mutation
            .withLatestFrom(state, resultSelector: { (mutation, state) -> (Mutation, State) in
                return (mutation, state)
            })
            .compactMap { [weak self] (mutation, state) in
                self?.reduce(previousState: state, mutation: mutation)
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
}
