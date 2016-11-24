//
//  SocketManager.swift
//  ChatExample
//
//  Created by Ellina Kuznecova on 24.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import SocketRocket
import JSQMessagesViewController

protocol SocketManagerDelegate: class {
    func connectionOpened()
    func connectionFailed(error: Error)
    func connectionClosed()
    func receivedMessage(message: JSQMessage)
}

class SocketManager: NSObject {
    
    var webSocket: SRWebSocket?
    weak var delegate: SocketManagerDelegate?
    
    override init() {
        super.init()
    
        self.webSocket = SRWebSocket(url: URL(string: "wss://echo.websocket.org")!)
        self.webSocket?.delegate = self
        self.webSocket?.open()
    }
    
    func closeConnection() {
        self.webSocket?.close()
    }
    
    func sendMessage(message: JSQMessage) {
        //message convertion
        self.webSocket?.send("")
    }
}

extension SocketManager: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket, didReceiveMessage: Any) {
        guard didReceiveMessage is String else {return}
        //string parsing
//        self.delegate?.receivedMessage(message: JSQMessage())
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        self.delegate?.connectionOpened()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        self.delegate?.connectionFailed(error: error)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        self.delegate?.connectionClosed()
    }
}
