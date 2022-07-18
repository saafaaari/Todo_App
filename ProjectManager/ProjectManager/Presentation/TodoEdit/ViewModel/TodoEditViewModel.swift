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
    func doneButtonDidTap()
    func inputitle(title: String?)
    func inputDeadline(deadline: Date)
    func inputBody(body: String?)
}

protocol TodoEditViewModelOutput {
    var setUpView: Observable<TodoModel?> { get }
    var setCreateMode: Observable<Bool> { get }
}

protocol TodoEditViewModel: TodoEditViewModelInput, TodoEditViewModelOutput {}

final class DefaultTodoEditViewModel: TodoEditViewModel {
    private let useCase: TodoListUseCase
    
    private var actions: TodoEditViewModelActions?
    
    private var item: TodoModel?
    
    init(useCase: TodoListUseCase, actions: TodoEditViewModelActions, item: TodoModel?) {
        self.useCase = useCase
        self.actions = actions
        self.item = item
    }
    
    var setUpView: Observable<TodoModel?> {
        if let item = item {
            return Observable.just(item)
        } else {
            return Observable.just(nil)
        }
    }
    
    var setCreateMode: Observable<Bool> {
        setUpView.map { item in
            if item == nil {
                return true
            } else {
                return false
            }
        }
    }
    
    func cancelButtonDidTap() {
        actions?.dismiss()
    }
    
    func doneButtonDidTap() {
        guard let item = item else {
            actions?.dismiss()
            return
        }
        useCase.saveItem(to: item)
        actions?.dismiss()
    }
    
    func inputitle(title: String?) {
        if title?.isEmpty == true { return }
        makeEmptyTodoItem()
        item?.title = title
    }
    
    func inputDeadline(deadline: Date) {
        item?.deadlineAt = deadline
    }
    
    func inputBody(body: String?) {
        if body?.isEmpty == true { return }
        makeEmptyTodoItem()
        item?.body = body
    }
    
    private func makeEmptyTodoItem() {
        guard item == nil else { return }
        item = TodoModel(title: nil, body: nil, deadlineAt: Date())
    }
}
