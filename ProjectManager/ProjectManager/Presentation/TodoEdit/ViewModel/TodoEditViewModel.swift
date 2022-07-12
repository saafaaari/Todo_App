//
//  TodoEditViewModel.swift
//  ProjectManager
//
//  Created by 이시원 on 2022/07/09.
//

import Foundation
import RxSwift

struct TodoEditViewModelActions {
    let dismiss: () -> Void
}

protocol TodoEditViewModelInput {
    func cancelButtonDidTap()
    func doneButtonDidTap(item: TodoModel)
}

protocol TodoEditViewModel: TodoEditViewModelInput {}

final class DefaultTodoEditViewModel: TodoEditViewModel {
    private let useCase: UseCase
    
    private var actions: TodoEditViewModelActions?
    
    init(useCase: UseCase, actions: TodoEditViewModelActions) {
        self.useCase = useCase
        self.actions = actions
    }
    
    func cancelButtonDidTap() {
        actions?.dismiss()
    }
    
    func doneButtonDidTap(item: TodoModel) {
        useCase.saveRepository(to: item)
        actions?.dismiss()
    }
}