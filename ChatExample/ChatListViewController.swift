//
//  ChatListViewController.swift
//  ChatExample
//
//  Created by Ellina Kuznecova on 24.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import Alamofire

class ChatListViewController: UIViewController {
    
    struct SegueData {
        static var toDetailChat = "toDetailChat"
        
        var selectedChat: ENChat
        
        init(selectedChat: ENChat) {
            self.selectedChat = selectedChat
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var request:DataRequest?
    
    var chats: [ENChat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let senderData = sender as? SegueData else {return}
        (segue.destination as? ConversationViewController)?.chat = senderData.selectedChat
    }
    
    func loadChats() {
        self.request = Router.Chat.getAll.request().responseObject({ [weak self] (response: DataResponse<RTChatListResponse>) in
            switch response.result {
            case .success(let value):
                self?.chats = value.chats
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic")!
        cell.textLabel?.text = chats[indexPath.row].name
        return cell
    }
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueData.toDetailChat, sender: SegueData(selectedChat: self.chats[indexPath.row]))
    }
}
