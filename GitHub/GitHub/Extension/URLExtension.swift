//
//  URLExtension.swift
//  iTunes
//
//  Created by Rafael Escaleira on 21/11/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import Foundation

public extension URL {
    
    enum HTTPMethod: String {
        
        case connect = "CONNECT"
        case delete  = "DELETE"
        case get     = "GET"
        case head    = "HEAD"
        case options = "OPTIONS"
        case patch   = "PATCH"
        case post    = "POST"
        case put     = "PUT"
        case trace   = "TRACE"
    }
}
