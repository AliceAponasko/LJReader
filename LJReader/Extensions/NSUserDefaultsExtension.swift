//
//  NSUserDefaultsExtension.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/29/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import Foundation

public enum UserDefaultsKey: String {
    case Authors = "Authors"
}

extension NSUserDefaults {
    
    func authors() -> [String]? {
        if let result = arrayForKey(UserDefaultsKey.Authors.rawValue) {
            return result as? [String]
        } else {
            return nil
        }
    }
    
    func addAuthor(author: String) {
        if var authors = authors() {
            if !authors.contains(author) {
                authors.append(author)
                setAuthors(authors)
            }
        } else {
           setAuthors([author])
        }
    }
    
    func setAuthors(authors: [String]) {
        setObject(authors, forKey: UserDefaultsKey.Authors.rawValue)
        synchronize()
    }
    
    func removeAuthor(author: String) {
        if var authors = authors() {
            if authors.contains(author) {
                guard let index = authors.indexOf(author) else {
                    return
                }
                
                authors.removeAtIndex(index)
                setAuthors(authors)
            }
        }
    }
    
    func removeAuthors() {
        setObject(nil, forKey: UserDefaultsKey.Authors.rawValue)
        synchronize()
    }
}