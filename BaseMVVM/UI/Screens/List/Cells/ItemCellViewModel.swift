//
//  ItemCellViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/29/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation

class ItemCellViewModel: CellViewModel {
    let item: Todo
    
    init(item: Todo) {
        self.item = item
        super.init()
        self.title.accept(item.title)
        self.notes.accept(item.notes)
        self.id.accept(item.id)
        self.category.accept(item.category)
        self.dueDate.accept(item.dueDate)
        self.isCompleted.accept(item.isCompleted)
    }
}
