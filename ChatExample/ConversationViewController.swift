//
//  ViewController.swift
//  ChatExample
//
//  Created by Ellina Kuznecova on 24.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Alamofire

class ConversationViewController: JSQMessagesViewController {
    
    var messages = LoadFakeData()
    var chat: ENChat?
    var incomingBubbleData   :JSQMessageBubbleImageDataSource!
    var outgoingBubbleData  :JSQMessageBubbleImageDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "0"
        self.senderDisplayName = "Vasya"
        
        self.incomingBubbleData = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: #colorLiteral(red: 0.15329051, green: 0.6822410479, blue: 1, alpha: 1))
        self.outgoingBubbleData = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    func loadMessages() {
        guard let id = self.chat?.id else {return}
        let _ = Router.Message.getAll(id: id).request().responseObject { (response: DataResponse<RTMessageListResponse>) in
            switch response.result {
            case .success(let value):
                return
//                self.messages = value.messages
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ConversationViewController {
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.row]
        return message.senderId == self.senderId ? self.outgoingBubbleData : self.incomingBubbleData
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: Date(), text: text)!
        self.messages.append(message)
        
        self.finishSendingMessage()
    }
}

func LoadFakeData(count: Int = 10) -> [JSQMessage] {
    var result: [JSQMessage] = []
    var i = 0
    while i < count {
        let senderId = arc4random()%2 == 0 ? 0 : 1
        let name = senderId == 0 ? "Vasya" : "Petya"
        let text = RandomString(length: Int(arc4random()%20))
        result.append(JSQMessage(senderId: "\(senderId)",
                                 senderDisplayName: name,
                                 date: Date(),
                                 text: text))
        i += 1
    }
    return result
}

func RandomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

