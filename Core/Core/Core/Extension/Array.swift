//
//  Array.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/27/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
