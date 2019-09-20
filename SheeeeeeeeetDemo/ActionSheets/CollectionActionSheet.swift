//
//  CollectionActionSheet.swift
//  SheeeeeeeeetExample
//
//  Created by Jonas Ullström on 2018-03-16.
//  Copyright © 2018 Jonas Ullström. All rights reserved.
//

import Sheeeeeeeeet

/**
 This action sheet takes a `Menu` and adjusts any collection
 items it may have, so that the generated action sheet items
 correctly update the action sheet.
 
 `IMPORTANT` Action sheets with `ActionSheetCollectionItem`s
 that are mapped from `CollectionItem`s must adjust the item
 select action, if it wants to be able to listen for taps in
 the collection view. You don't have to do it in this way if
 you create an `ActionSheetCollectionItem` directly from the
 action sheet, since the sheet can then refer to itself when
 setting up the select action.
 */
class CollectionActionSheet: ActionSheet {
    
    typealias Menu = CollectionMenu
    
    convenience init(menu: Menu, action: @escaping ([Menu.Cell.Item]) -> ()) {
        self.init(menu: menu) { _, item in
            guard item.isOkButton else { return }
            action(menu.selectedItems)
        }
        
        let sectionTitle = self.items.compactMap { $0 as? ActionSheetSectionTitle }.first
        let sheetCollectionItem = self.items.compactMap { $0 as? ActionSheetCollectionItem<Menu.Cell> }.first
        let selectionAction = sheetCollectionItem?.selectionAction
        sheetCollectionItem?.selectionAction = { [weak self] cell, index in
            selectionAction?(cell, index)
            let selectedCount = menu.collectionItems.filter { $0.isSelected }.count
            sectionTitle?.subtitle = "Selected items: \(selectedCount)"
            self?.reloadData()
        }
    }
}
