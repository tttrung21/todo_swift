//
//  CellViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 1/4/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CellViewModel {
    var disposeBag = DisposeBag()
    
    let id = BehaviorRelay<Int?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let notes = BehaviorRelay<String?>(value: nil)
    let category = BehaviorRelay<String?>(value: nil)
    let dueDate = BehaviorRelay<String?>(value: nil)
    let dueTime = BehaviorRelay<String?>(value: nil)
    let isCompleted = BehaviorRelay<Bool>(value: false)
}
