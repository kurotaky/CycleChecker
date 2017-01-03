//
//  CycleChangerApi.swift
//  CycleChecker
//
//  Created by usr0600244 on 2017/02/02.
//  Copyright © 2017年 org.mo-fu. All rights reserved.
//

import Foundation
import APIKit

struct CycleChangerApiRequest: Request {
    typealias Response = Item
    
    var baseURL: URL {
        return URL(string: "https://desolate-ridge-29818.herokuapp.com")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/items"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Item {
        return try Item(object: object)
    }
}

struct Item {
    let items: NSArray
    
    init(object: Any) throws {
        let dictionary = object as? NSArray
        let items = dictionary
        self.items = items!
    }
}
