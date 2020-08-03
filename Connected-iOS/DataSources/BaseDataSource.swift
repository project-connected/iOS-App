//
//  BaseDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

open class BaseDataSource: NSObject, UICollectionViewDataSource, UITableViewDataSource {

    private var items: [[(item: Any, reusableId: String)]] = []

    // MARK: - Functions

    public final func itemCountInSection(section: Int) -> Int {
        guard section < items.count else { return 0 }
        return items[section].count
    }

    public final func itemCount() -> Int {
        return items.map { $0.count }.reduce(0, +)
    }

    public final func sectionCount() -> Int {
        return items.count
    }

    public final func clearItems() {
        items = []
    }

    public final func clearSection(section: Int) {
        guard section < items.count else { return }
        items[section] = []
    }

    public final func set<Cell: BaseCell, Item: Any>(
        items: [Item],
        cellClass: Cell.Type,
        section: Int
    ) where Cell.Item == Item {
        if self.items.count <= section {
            self.items += [[(item: Any, reusableId: String)]](
                repeating: [],
                count: section - self.items.count + 1
            )
        }
        self.items[section] = items.map { ($0, Cell.reusableId) }
    }

    public final subscript(indexPath: IndexPath) -> Any {
        return items[indexPath.section][indexPath.item].item
    }

    open func configureCell(collectionCell cell: UICollectionViewCell, with item: Any) { }
    open func configureCell(tableCell cell: UITableViewCell, with item: Any) { }

    // MARK: - CollectionViewDataSource

    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }

    public final func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let (item, reusableId) = items[indexPath.section][indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath)
        configureCell(collectionCell: cell, with: item)
        return cell
    }

    // MARK: - TableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (item, reusableId) = items[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath)
        configureCell(tableCell: cell, with: item)
        return cell
    }

}
