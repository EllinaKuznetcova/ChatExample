//
//  RTChat.swift
//  ChatExample
//
//  Created by Ellina Kuznecova on 24.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import ObjectMapper

extension Router {
    enum Chat {
        case getAll
        case createNew(name: String)
    }
}

extension Router.Chat: RouterProtocol {
    var settings: RTRequestSettings {
        switch self {
        case .getAll    : return RTRequestSettings(method: .get)
        case .createNew : return RTRequestSettings(method: .post)
        }
    }
    
    var path: String {
        return "/rooms"
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getAll                : return nil
        case .createNew(let name)   : return ["room":["title": name] as AnyObject]
        }
    }
}

class RTChatListResponse: Mappable {
    var chats: [ENChat] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
}
