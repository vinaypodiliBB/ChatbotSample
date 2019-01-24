//
//  BBChatViewController.swift
//  ChatbotSample
//
//  Created by Vinay Podili on 24/01/19.
//  Copyright © 2019 Brighterbee. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ApiAI
import Speech
enum ChatWindowStatus
{
    case minimised
    case maximised
}
class BBChatViewController: JSQMessagesViewController {
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    lazy var speechSyntesizer = AVSpeechSynthesizer()
    lazy var botImageView = UIImageView()
    var chatWindowStatus : ChatWindowStatus = .maximised
    var botImageTapGesture: UITapGestureRecognizer?
    var messages = [JSQMessage]()
    override func viewDidLoad() {
      super.viewDidLoad()
        
        
        
        self.senderId = "some userId"
        self.senderDisplayName = "some userName"
        SpeechManager.shared.delegate = self
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        self.view.addGestureRecognizer(swipeGesture)
        self.addMicButton()
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.populateWithWelcomeMessage()
        })
        // Do any additional setup after loading the view.
    }
//    //Your initial view controller
//    override func viewDidAppear(_ animated: Bool) {
//        let chatVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as? BBChatViewController
//        UIView.animate(withDuration: 0.5) {
//            chatVc?.view.frame = CGRect(x: self.view.frame.origin.x, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 20)
//            self.view.addSubview((chatVc?.view)!)
//            self.addChild(chatVc!)
//            self.didMove(toParent: chatVc)
//        }
//    }
    //MARK: Helper Methods
    func addMicButton()
    {
        let height = self.inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
        let micButton = UIButton(type: .custom)
        micButton.setImage(UIImage(named: "mic"), for: .normal)
        micButton.frame = CGRect(x: 0, y: 0, width: 25, height: height)
        
        self.inputToolbar.contentView.leftBarButtonItemWidth = 25
        self.inputToolbar.contentView.leftBarButtonContainerView.addSubview(micButton)
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOfMic(gesture:)))
        micButton.addGestureRecognizer(longPressGesture)
    }
    func populateWithWelcomeMessage()
    {
        self.addMessage(withId: "BotId", name: "Bot", text: "Hi I am Basky")
        self.addMessage(withId: "BotId", name: "Bot", text: "I am here to help you about anything related to the Math expressions")
        self.addMessage(withId: "BotId", name: "Bot", text: "At any moment you feel that I am troubling you, you can ask me sit quiet or swipe on the screen")
        self.finishReceivingMessage()
    }
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            
            messages.append(message)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func minimiseBot()
    {
        if chatWindowStatus == .maximised
        {
            self.inputToolbar.contentView.textView.resignFirstResponder()
            UIView.animate(withDuration: 0.5, animations: {
                let rect = CGRect(x: 300, y: 50, width: 70, height: 70)
                self.view.frame = rect
                self.view.clipsToBounds = true
                self.view.layer.cornerRadius = 35
            }, completion: { [weak self] (completed) in
//                self?.inputToolbar.isUserInteractionEnabled = false
                self?.inputToolbar.isUserInteractionEnabled = true

                self?.botImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
                self?.botImageView.image =  UIImage(named: "boticon") //imageLiteral(resourceName: "BotImage")
                self?.botImageView.clipsToBounds = true
                self?.botImageView.layer.cornerRadius = 35
                self?.view.addSubview((self?.botImageView)!)
                self?.chatWindowStatus = .minimised
                self?.view.layer.cornerRadius = 0
                self?.botImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.handleTap(gesture:)))
                self?.view.addGestureRecognizer((self?.botImageTapGesture!)!)
            })
        }
    }
    @objc func handleLongPressOfMic(gesture:UILongPressGestureRecognizer)
    {
        if gesture.state == .began
        {
            SpeechManager.shared.startRecording()
        }
        else if gesture.state == .ended
        {
            SpeechManager.shared.stopRecording()
            if inputToolbar.contentView.textView.text == "Say something, I'm listening!"
            {
                inputToolbar.contentView.textView.text = ""
            }
        }
    }
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        minimiseBot()
    }
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if chatWindowStatus == .minimised {
            botImageView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view.frame = rect
                self.view.clipsToBounds = true
                self.chatWindowStatus = .maximised

            }) { (completed) in
               self.inputToolbar.isUserInteractionEnabled = true
                
            self.view.removeGestureRecognizer(self.botImageTapGesture!)
            }
        }
    }
}
extension BBChatViewController: SpeechManagerDelegate {
    func didStartedListening(status: Bool) {
        if status {
            self.inputToolbar.contentView.textView.text = "Say something, I'm listening!"
        }
    }
    func didReceiveText(text: String) {
       self.inputToolbar.contentView.textView.text = text
        if text != "Say something, I'm listening!" {
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
    }
}
extension BBChatViewController {
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        }else {
            return incomingBubbleImageView
        }
    }
    //Removing avatars
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        }else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        addMessage(withId: senderId, name: senderDisplayName, text: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        performQuery(senderId: senderId, name: senderDisplayName, text: text)
    }
    func performQuery(senderId:String,name:String,text:String) {
        let request = ApiAI.shared().textRequest()
        if text != "" {
            request?.query = text
        }
        else {
            return
        }
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if response.result.action == "bot.quit" {
                if let parameters = response.result.parameters as? [String:AIResponseParameter]
                {
                    if let quit = parameters["quit"]?.stringValue
                    {
                        let deadlineTime = DispatchTime.now() + .seconds(2)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                            self.minimiseBot()
                        })
                    }
                }
            }
            if let textResponse = response.result.fulfillment.speech
            {
                if textResponse != "" {
                    SpeechManager.shared.speak(text: textResponse)

                let parts = textResponse.components(separatedBy: "=")

                let prefix = parts[0]
                    if prefix == "imgUrl" {
                        let url = URL(string: textResponse.deletingPrefix(prefix + "="))
                        if let data = try? Data(contentsOf: url!) {
                             //   let image = UIImage(data: data)
                            let image = UIImage(named: "Triangle")
                            if let photoItem = JSQPhotoMediaItem(image: image) {
                                self.addMedia(photoItem, "Bot", "BotId")
                            }
                        }
                        //self.addMessage(withId: "BotId", name: "Bot", text: textResponse)
                    }else {
                        self.addMessage(withId: "BotId", name: "Bot", text: textResponse)
                    }
              //  self.addMessage(withId: "BotId", name: "Bot", text: textResponse)
                self.finishReceivingMessage()
                }
            }
        }, failure: { (request, error) in
            print(error)
        })
        ApiAI.shared().enqueue(request)
    }
}
extension BBChatViewController {
    func addMedia(_ media:JSQMediaItem, _ displayname: String, _ withId: String) {
        if let message = JSQMessage(senderId: self.senderId(), displayName: displayname, media: media) {
        self.messages.append(message)
        }
        
        //Optional: play sent sound
        
        self.finishSendingMessage(animated: true)
    }
}
