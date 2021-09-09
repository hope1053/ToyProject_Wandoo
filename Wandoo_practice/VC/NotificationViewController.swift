//
//  NotificationViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/07/27.
//

import UIKit
import Foundation
import UserNotifications

class NotificationViewController: UIViewController {
    @IBOutlet weak var isSaved: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var receiveAlram: UISwitch!
    @IBOutlet weak var notiTime: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTime()
        setSwitch()
        updateUIstatus(UserDefaults.standard.bool(forKey: "wantAlarm"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendNoti()
    }
    
    func sendNoti() {
        notificationCenter.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "오늘도 Wandoo와 함께 완주해봐요!"
        content.body = "지난 진도를 체크하고 앞으로의 계획을 함께 세워봐요 :)"

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour, .minute], from: timePicker.date), repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        if UserDefaults.standard.bool(forKey: "wantAlarm") {
            notificationCenter.add(request) { (error) in
                if error != nil {
                    // handle errors
                }
            }
        }
    }
    
    func updateTime() {
        if let savedTime = UserDefaults.standard.string(forKey: "notiTime") {
            notiTime.text = savedTime
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            let savedDate = dateformatter.date(from: savedTime)!
            timePicker.date = savedDate
        }
    }
    
    func setSwitch() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async{
                    self.receiveAlram.setOn(false, animated: false)
                    UserDefaults.standard.setValue(false, forKey: "wantAlarm")
                    self.updateUIstatus(false)
                }
            } else {
                DispatchQueue.main.async{
                    self.receiveAlram.setOn(UserDefaults.standard.bool(forKey: "wantAlarm"), animated: false)
                }
            }
        }
    }
    
    @IBAction func switched(_ sender: Any) {
        let isSwitchOn = receiveAlram.isOn
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied && isSwitchOn == true {
                DispatchQueue.main.async{
                    self.receiveAlram.setOn(false, animated: false)
                    self.popupAlertView()
                }
            } else {
                DispatchQueue.main.async{
                    self.updateUIstatus(isSwitchOn)
                    UserDefaults.standard.setValue(isSwitchOn, forKey: "wantAlarm")
                }
            }
        }
    }
    
    func popupAlertView() {
        let alert = UIAlertController(title: "지금은 알림을 받을 수 없어요!🥲", message: "리마인드 알림을 위해서 알림 권한을 허용해주세요!", preferredStyle: UIAlertController.Style.alert)

        let setAlertAction =  UIAlertAction(title: "설정하기", style: UIAlertAction.Style.destructive){_ in
            let url = URL(string:UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)

        alert.addAction(setAlertAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    
    func saveTime() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        let dateText = dateformatter.string(from: timePicker.date)
        UserDefaults.standard.setValue(dateText, forKey: "notiTime")
    }
    
    func updateUIstatus(_ isOn: Bool) {
        if isOn {
            notiTime.alpha = 1
            firstLabel.alpha = 1
            secondLabel.alpha = 1
            timePicker.isEnabled = true
        } else {
            notiTime.alpha = 0.5
            firstLabel.alpha = 0.5
            secondLabel.alpha = 0.5
            timePicker.isEnabled = false
        }
    }
    
    @IBAction func timeChanged(_ sender: Any) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        let dateText = dateformatter.string(from: timePicker.date)
        notiTime.text = dateText
        saveTime()
        sendNoti()
    }
    

}
