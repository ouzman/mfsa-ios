//
//  Publisher+Ext.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 31.12.2020.
//

import Combine

extension Publisher where Output: Sequence {
    typealias Sorter = (Output.Element, Output.Element) -> Bool

    func sort(
        by sorter: @escaping Sorter
    ) -> Publishers.Map<Self, [Output.Element]> {
        map { sequence in
            sequence.sorted(by: sorter)
        }
    }
}
