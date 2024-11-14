//
//  StringExtensions.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 1/4/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation

// MARK: - Methods
public extension String {
    #if canImport(Foundation)
    /// SwifterSwift: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized() -> String {
//        return NSLocalizedString(self,tableName: "Localizable",bundle: .main,value: self, comment: self)
        if let path = Bundle.main.path(forResource: LanguageCode, ofType: "lproj"), let bundle = Bundle(path: path){
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return ""
    }
    #endif
}
