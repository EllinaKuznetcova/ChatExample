//
//  RTMessages.swift
//  ChatExample
//
//  Created by Ellina Kuznecova on 24.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import ObjectMapper

extension Router {
    enum Message {
        case getAll(id: Int)
    }
}

extension Router.Message: RouterProtocol {
    var settings: RTRequestSettings {
        return RTRequestSettings(method: .get)
    }
    
    var path: String {
        switch self {
            case .getAll(let id): return "/rooms/\(id)/messages"
        }
    }
    
    var parameters: [String : AnyObject]? {
        return nil
    }
}

class RTMessageListResponse: Mappable {
    var messages: [ENMessage] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
}
