//
//  ViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/27.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var tmpLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var lectureTable: UITableView!
    
    let viewModel = DetailViewModel()
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBAction func unwind(_ segue: UIStoryboardSegue){
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewModel.loadTasks()
        showAddLable()
        settingButton.tintColor = buttonColorForDarkMode
        
        // 강의를 추가한 경우 noti를 받음
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissaddNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissaddViewController"), object: nil)
        // Detail ViewController에서 빠져나온 경우 noti를 받음(내용을 수정한 경우 반영)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissDetailNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissaDetailViewController"), object: nil)
        // Detail ViewController 혹은 main 화면에서 강의를 삭제한 경우 noti를 받음
        NotificationCenter.default.addObserver(self, selector: #selector(self.DeletedDetailNotification(_:)), name: NSNotification.Name(rawValue: "DeletedDetailViewController"), object: nil)
        
        requestNotificationAuthorization()
        self.setupGenerator()
    }
    
    private func setupGenerator() {
        self.feedbackGenerator = UINotificationFeedbackGenerator()
        self.feedbackGenerator?.prepare()
    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func showAddLable() {
        if viewModel.numOfLec == 0 {
            noResultLabel.alpha = 0.5
        } else {
            noResultLabel.alpha = 0
        }
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-80, width: 200, height: 35))
        toastLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2771671603)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 15
        toastLabel.clipsToBounds = true
        
        
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { toastLabel.alpha = 1.0 }, completion: {(isCompleted) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in
                            toastLabel.removeFromSuperview()
            })
        })
    }
    
    @objc func didDismissaddNotification(_ noti: Notification) {
            OperationQueue.main.addOperation {
                self.lectureTable.reloadData()
                self.viewModel.loadTasks()
                self.showAddLable()
                self.feedbackGenerator?.notificationOccurred(.success)
                self.showToast(message: "강의가 추가되었습니다(ღ'ᴗ'ღ) ", font: UIFont(name: "GmarketSansMedium", size: 14)!)
            }
    }
    
    @objc func didDismissDetailNotification(_ noti: Notification) {
            OperationQueue.main.addOperation {
                self.lectureTable.reloadData()
                self.viewModel.loadTasks()
            }
    }
    
    @objc func DeletedDetailNotification(_ noti: Notification) {
            OperationQueue.main.addOperation {
                self.lectureTable.reloadData()
                self.viewModel.loadTasks()
                self.showAddLable()
                self.feedbackGenerator?.notificationOccurred(.success)
                self.showToast(message: "강의가 삭제되었습니다(ღ'ᴗ'ღ) ", font: UIFont(name: "GmarketSansMedium", size: 14)!)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                let lecInfo = viewModel.lectures[index]
                vc?.viewModel.update(model: lecInfo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfLec
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else{
            return UITableViewCell()
        }
        let lecture = viewModel.lectures[indexPath.row]
        let viewWidth = mainView.bounds.width
        cell.updateUI(info: lecture, width: viewWidth)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.deleteLec(viewModel.lectures[indexPath.item])
            showToast(message: "강의가 삭제되었습니다 'ㅇ'", font: UIFont(name: "GmarketSansMedium", size: 15)!)
            lectureTable.reloadData()
            showAddLable()
        }
    }
    
    @IBAction func getInfo(_ sender: Any) {
        performSegue(withIdentifier: "getInfo", sender: nil)
    }
    
    
}

class ListCell: UITableViewCell {
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var bgBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var doneNumofLec: UILabel!
    
    
    @IBOutlet weak var progressWidth: NSLayoutConstraint!
    
    func updateUI(info: LectureInfo, width: CGFloat){
        lectureLabel.text = info.name
        dateLabel.text = info.date
        numLabel.text = "\(info.numOfLec)"
        progressBar.layer.cornerRadius = 9
        bgBar.layer.cornerRadius = 9
        doneNumofLec.text = String(info.isDone.filter{$0}.count)
        let numOfTrue = Double(info.doneNumOfLec) / Double(info.numOfLec)!
        progressWidth.constant = (width - 50) * (0.05 + 0.95 * CGFloat(numOfTrue))
    }
}
