//
//  String+.swift
//
//  Created by Trick Gorospe on 8/29/21.
//

import Foundation

extension String {
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
            return "(null)"
        } as [CVarArg]

        return String.init(format: self, arguments: args)
    }
}
