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
    }
}

extension Router.Chat: RouterProtocol {
    var settings: RTRequestSettings {
        return RTRequestSettings(method: .get)
    }
    
    var path: String {
        return ""
    }
    
    var parameters: [String : AnyObject]? {
        return nil
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
