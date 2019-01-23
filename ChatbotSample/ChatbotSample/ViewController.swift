//
//  ViewController.swift
//  ChatbotSample
//
//  Created by Vinay Podili on 22/01/19.
//  Copyright © 2019 Brighterbee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var msgTextView: UITextView!
    
    let outCellId = "outCellId"
    @IBOutlet weak var tblView: UITableView!
    let incomingCellId = "incomingCellId"
    var mesgsArray = [["text" : "Hi", "msgType" : "user", "timestamp" : "7:34 pm"], ["text" : "Hello", "msgType" : "agent", "timestamp" : "7:34 pm"], ["text" :  "Who are you?", "msgType" : "user", "timestamp" : "7:35 pm"], ["text" :  "Who are you?", "msgType" : "agent", "timestamp" : "7:35 pm"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.estimatedRowHeight = 100
        self.msgTextView.delegate = self
        self.msgTextView.layer.borderWidth = 0.3
        self.msgTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.msgTextView.layer.cornerRadius = 5
        self.tblView.tableFooterView = UIView()
        //tblView.rowHeight =
        // Do any additional setup after loading the view, typically from a nib.
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if msgTextView.text != "" {
            let timeStamp = Date().currentLocaleDate
            let dict = ["text" : self.msgTextView.text ?? "", "msgType" : "user", "timestamp" : timeStamp]
            self.mesgsArray.append(dict)
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.msgTextView.text = ""
                self.bottomViewHeightContraint.constant = 50
            }
        }
    }
}
extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Your code here
        let height = heightForView(text: textView.text, font: UIFont(name: "Helvetica", size: 16)!, width: textView.bounds.width)
        if height < 140 {
        bottomViewHeightContraint.constant =  ((textView.text) == "" || (height < 50)) ? 50 : height
        }
    }
}
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return mesgsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = mesgsArray[indexPath.section]
        let mesgType = obj["msgType"]
        if mesgType == "user" {
            let cell = tableView.dequeueReusableCell(withIdentifier: incomingCellId, for: indexPath) as! IncomingTVCell
            cell.userTextLabel.text = obj["text"] ?? ""
            cell.userIconView.layer.cornerRadius = 25
            cell.userIconView.image = UIImage(named: "avatar_m1")
            cell.timeLabel.text = obj["timestamp"] ?? ""
            cell.selectionStyle = .none
            return cell//self.showIncomingMessage(text: obj["text"] ?? "", cell: cell)
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: outCellId, for: indexPath) as! OutgoingTVCell
            cell.userTextLabel.text = obj["text"] ?? ""

            //cell.userTextLabel.text = obj["text"] ?? ""
            cell.userIconView.layer.cornerRadius = 25

            cell.userIconView.image = UIImage(named: "agent")
            cell.selectionStyle = .none

            return cell//self.showOutgoingMessage(text: obj["text"] ?? "", cell: cell)
        }
    }
}
extension ViewController {
   
    
    func showOutgoingMessage(text: String, cell: OutgoingTVCell) -> OutgoingTVCell {
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleSize = CGSize(width: label.frame.width + 28,
                                height: label.frame.height + 20)
        
        let width = bubbleSize.width
        let height = bubbleSize.height
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width - 22, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.close()
        
        let outgoingMessageLayer = CAShapeLayer()
        outgoingMessageLayer.path = bezierPath.cgPath
        outgoingMessageLayer.frame = CGRect(x: 20,
                                            y: view.frame.height/2 - height/2,
                                            width: width,
                                            height: height)
        outgoingMessageLayer.fillColor = UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1).cgColor
        
        cell.outgoingCellView.layer.addSublayer(outgoingMessageLayer)
        
        label.center = view.center
        cell.addSubview(label)
        return cell
    }
    func showIncomingMessage(text: String, cell: IncomingTVCell) -> IncomingTVCell {
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleSize = CGSize(width: label.frame.width + 28,
                                height: label.frame.height + 20)
        
        let width = bubbleSize.width
        let height = bubbleSize.height
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width - 22, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.close()
        
        let incomingMessageLayer = CAShapeLayer()
        incomingMessageLayer.path = bezierPath.cgPath
        incomingMessageLayer.frame = CGRect(x: width - 20,
                                            y: view.frame.height/2 - height/2,
                                            width: width,
                                            height: height)
        incomingMessageLayer.fillColor = UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1).cgColor
        
        cell.contentView.layer.addSublayer(incomingMessageLayer)
        
        label.center = view.center
        cell.addSubview(label)
        return cell
    }
}
class IncomingTVCell: UITableViewCell {
    @IBOutlet weak var userTextLabel: UILabel!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var incomingCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        incomingCellView.layer.borderWidth = 0.5
        incomingCellView.layer.borderColor = UIColor.blue.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
class OutgoingTVCell: UITableViewCell {
    
    @IBOutlet weak var outgoingCellView: UIView!
    @IBOutlet weak var userTextLabel: UILabel!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        outgoingCellView.layer.borderWidth = 0.5
        outgoingCellView.layer.borderColor = UIColor.orange.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
