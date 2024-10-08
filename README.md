# mvvmxreactor
MVVM &amp; Reactor

In software development, the ViewModel structure is an essential component in patterns like MVVM (Model-View-ViewModel) and Redux. Both approaches aim to manage the state and behavior of the user interface, but they do so in different ways. Here's a breakdown of how a ViewModel can be structured by blending the principles of MVVM and Redux.

ViewModel Based on MVVM and Redux
The ViewModel serves as a mediator between the View (UI) and the Model (data). It encapsulates the logic needed to handle the state of the UI, while keeping the View unaware of the data source or business logic. The ViewModel can be designed using ideas from MVVM and Redux to achieve a clear separation of concerns, state management, and reactivity.

MVVM Structure in the ViewModel:

Model: Represents the data and business logic. In an MVVM architecture, the model is independent of the user interface and is responsible for fetching, storing, and processing data.
View: The UI that is responsible for displaying data. The view is "dumb," meaning it doesn't contain any business logic. Instead, it reacts to the state changes provided by the ViewModel.
ViewModel: It acts as an intermediary, exposing data from the model to the view in a format suitable for presentation. The ViewModel observes changes in the model and updates the view accordingly.
Redux Principles in the ViewModel:

Single Source of Truth: The ViewModel can maintain a single, immutable state object that holds all the information required to render the UI. Any changes to the state are only done via actions.
Unidirectional Data Flow: Inspired by Redux, the ViewModel can manage state changes through an unidirectional data flow. The view sends actions or commands (like user interactions) to the ViewModel, which then updates the state. The new state triggers a view update.
State Management: Like in Redux, the state in the ViewModel can be updated through reducers. When an action is dispatched, the state is modified, and the updated state is sent back to the view.

Based on ReactorKit (https://github.com/ReactorKit/ReactorKit)
Usage: conform your VM to this protocol and call `.setupFlow(disposeBag:)` in the `init` method or viewDidload in VC.

Main components:
  - `state`: The current state of the View (used to display the UI)
  - `action`: Actions performed by the view
  - `mutation`: Not to be used in the View. Mutations (transformations) of the view (listened to in the `func mutate(action: Action, with state: State)` function)

MVVM Data Flow:
1. View -> Action -> mutation -> Model
     - `action` -> bind/subscribe -> `mutate(action: Action, with state: State)` -> `mutation`

2. Model -> ViewModel -> View
     - `mutation` -> accept -> `reduce(previousState: State, mutation: Mutation) -> State?` -> `state`

3. The View listens to the state via subscribe to update the UI

# Swift Code Examples

## Demo ViewModel

This example basic viewmodel conform BaseMVVMReactorVM.

```swift
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
```

## Demo VC

This example basic VC using VM.

```swift
import UIKit
import RxSwift

class ViewController: UIViewController {

    private
    var viewModel: DemoViewModel!
    
    private
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = DemoViewModel()
        viewModel.setupFlow(disposeBag: disposeBag)
        bindViewModel()
    }
    
}

extension ViewController{
    private
    func bindViewModel(){
        self.viewModel
            .state
            .map{$0.isLoading}
            .subscribe(onNext:{ [weak self] isLoading in
                ///listen loading state
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController{
    //Make action
    private
    func actionA(){
        self.viewModel.action.accept(.getData)
    }
}

```

