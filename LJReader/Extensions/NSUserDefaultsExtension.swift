//
//  NSUserDefaultsExtension.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/29/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import Foundation

extension NSUserDefaults {

    struct Key {
        static let authors = "Authors"
    }
    
    func authors() -> [String]? {
        return arrayForKey(Key.authors) as? [String]
    }
    
    func addAuthor(author: String) {
        guard var authors = authors() else {
            setAuthors([author])
            return
        }

        if !authors.contains(author) {
            authors.append(author)
            setAuthors(authors)
        }
    }

    func setAuthors(authors: [String]) {
        setObject(authors, forKey: Key.authors)
        synchronize()
    }
    
    func removeAuthor(author: String) {
        guard var authors = authors() else {
            return
        }

        if authors.contains(author) {
            guard let index = authors.indexOf(author) else {
                return
            }

            authors.removeAtIndex(index)
            if authors.count > 0 {
                setAuthors(authors)
            } else {
                removeAuthors()
            }
        }
    }

    func removeAuthors() {
        setObject(nil, forKey: Key.authors)
        synchronize()
    }
}
