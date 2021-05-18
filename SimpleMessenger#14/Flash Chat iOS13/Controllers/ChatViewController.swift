//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase



class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
       // tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        // убрать кнопку back
        navigationItem.hidesBackButton = true
        
            // соеденяет собственный дизайн ячейки xib
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    // достает сообщения из бд, и показывает юзеру
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            //сортировка по вермени
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
            self.messages = []
            
            if let e = error {
                print(e)
            }
            if let snapshotDocument = querySnapshot?.documents {
                for doc in snapshotDocument {
                    let data = doc.data()
                    if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                        let newMessage = Message(sender: messageSender, body: messageBody)
                        self.messages.append(newMessage)
                        
                        
                        
                        DispatchQueue.main.async {
                            // при отправке сообщения обновляет список бд, и отображает отпрвленное сообщение
                            self.tableView.reloadData()
                            
                            // пролистывает в самый низ сообщения
                            // и при отправке нового автоматически показывает добавленое без пролистывания
                            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        
        
        // добавление нового сообщения в бд
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.bodyField: messageBody,
                K.FStore.senderField: messageSender,
                // добавление времени в бд
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
            if let e = error {
                print(e)
            } else {
                print("Success")

                self.messageTextfield.text = ""
            }
        }
        }
    }
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        // выход из чата на главный экран входа
        navigationController?.popToRootViewController(animated: true)
        // log out из авторизации
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}

// отвечает за заполение данных
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // для проверки корректного емайла
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        // если я пишу сообщения
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        // если другой пишет сообщения
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
}
// отвечает за выбранные строки
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}

