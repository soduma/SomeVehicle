//
//  GroupedSection.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import Foundation

struct GroupedSection<SectionItem : Hashable, RowItem> {
    var sectionItem : SectionItem
    var rows : [RowItem]
    
    static func group(rows : [RowItem], by criteria : (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: rows, by: criteria)
        return groups.map(GroupedSection.init(sectionItem:rows:))
    }
}
