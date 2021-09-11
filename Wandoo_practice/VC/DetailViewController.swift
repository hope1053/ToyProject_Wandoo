//
//  DetailViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/28.
//

import UIKit
import Lottie

class DetailViewController: UIViewController {
    
    var feedbackGenerator: UINotificationFeedbackGenerator?
    var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    let DidDismissaDetailViewController: Notification.Name = Notification.Name("DidDismissaDetailViewController")
    let DeletedDetailViewController: Notification.Name = Notification.Name("DeletedDetailViewController")
    
    @IBOutlet weak var bgBar: UIView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var doneLecNum: UILabel!
    
    @IBOutlet weak var progessWidth: NSLayoutConstraint!
    
    let viewModel = DetailViewModel()
    var tableViewContentHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissReviseNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissReviseViewController"), object: nil)
        self.tableView.rowHeight = 44
        moreButton.tintColor = buttonColorForDarkMode
        self.setupGenerator()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewContentHeight = tableView.contentSize.height
        setTableView(tableViewContentHeight)
    }
    
    private func setupGenerator() {
        self.feedbackGenerator = UINotificationFeedbackGenerator()
        self.feedbackGenerator?.prepare()
    }
    
    func setTableView(_ contentHeight: CGFloat){
        if tableView.frame.height > tableViewContentHeight {
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableViewContentHeight)
            detailView.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reviseSegue" {
            let vc = segue.destination as? ReviseViewController
            if let lecInfo = sender as? LectureInfo {
                vc?.viewModel.update(model: lecInfo)
            }
        }
    }

    @objc func didDismissReviseNotification(_ noti: Notification) {
            OperationQueue.main.addOperation {
                let newViewInfo = noti.object as? LectureInfo
                self.feedbackGenerator?.notificationOccurred(.success)
                self.viewModel.lecInfo = newViewInfo
//                self.viewModel.update(model: newViewInfo)
                self.tableView.reloadData()
                self.viewModel.loadTasks()
                self.updateUI()
            }
    }
    
    func updateUI(){
        if let lecInfo = self.viewModel.lecInfo {
            lectureLabel.text = lecInfo.name
            dateLabel.text = lecInfo.date
            numLabel.text = "\(lecInfo.numOfLec)"
            bgBar.layer.cornerRadius = 7
            progressBar.layer.cornerRadius = 7
            doneLecNum.text = String(lecInfo.isDone.filter{$0}.count)
            let numOfTrue = Double(lecInfo.doneNumOfLec) / Double(lecInfo.numOfLec)!
            progessWidth.constant = (detailView.bounds.width - 60) * (0.05 + 0.95 * CGFloat(numOfTrue))
        }
        self.tableView.separatorColor = buttonColorForDarkMode
        self.tableView.layer.masksToBounds = true
        self.tableView.layer.borderColor = buttonColorForDarkMode.cgColor
        self.tableView.layer.borderWidth = 2.0
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "unwind", sender: nil)
        NotificationCenter.default.post(name: DidDismissaDetailViewController, object: nil, userInfo: nil)
    }
    
    @IBAction func swipeLeftGesture(_ sender: Any) {
        performSegue(withIdentifier: "unwind", sender: nil)
        NotificationCenter.default.post(name: DidDismissaDetailViewController, object: nil, userInfo: nil)
    }
    
    // 해당 강의 관련 내용 수정 및 삭제 alert dialog 구현
    @IBAction func makeAlertDialog(_ sender: UIButton) {
        let alert = UIAlertController(title: viewModel.lecInfo?.name, message: nil, preferredStyle: .actionSheet)
        
        let lecture: LectureInfo = viewModel.lecInfo!
        
        let cacelBtn = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let deleteBtn = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            self.viewModel.deleteLec(lecture)
            NotificationCenter.default.post(name: self.DeletedDetailViewController, object: nil, userInfo: nil)
            self.performSegue(withIdentifier: "unwind", sender: nil)
        }
        let reviseBtn = UIAlertAction(title: "수정", style: .default) { (action) in
            self.performSegue(withIdentifier: "reviseSegue", sender: self.viewModel.lecInfo)
        }
        
        alert.addAction(reviseBtn)
        alert.addAction(deleteBtn)
        alert.addAction(cacelBtn)
        
        self.present(alert, animated: true, completion: {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        })
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(viewModel.lecInfo!.numOfLec)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as? checkLecture else {
            return UITableViewCell()
        }
        cell.num.text = String(indexPath.item + 1) + "강"
        var lecture = viewModel.lecInfo!
        cell.updateUI(lecture, indexPath.item)
        
        cell.doneButtonTapHandler = { isTapped in
            lecture.isDone[indexPath.item] = isTapped
            lecture.doneNumOfLec = lecture.isDone.filter{$0}.count
            self.viewModel.updateLec(lecture)
            self.viewModel.update(model: lecture)
            self.tableView.reloadData()
            self.setTableView(self.tableViewContentHeight)
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            
            self.doneLecNum.text = String(lecture.isDone.filter{$0}.count)
            let numOfTrue = Double(lecture.doneNumOfLec) / Double(lecture.numOfLec)!
            self.progessWidth.constant = (self.detailView.bounds.width - 60) * (0.05 + 0.95 * CGFloat(numOfTrue))
            
            self.selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            self.selectionFeedbackGenerator?.selectionChanged()

            if lecture.doneNumOfLec == Int(lecture.numOfLec) {
                let animationView = Lottie.AnimationView(name: "53513-confetti")

                animationView.frame = CGRect(x:0, y:100, width:400, height:400)
                animationView.contentMode = .scaleAspectFill
                animationView.isUserInteractionEnabled = false

                self.detailView.addSubview(animationView)
                animationView.play{ (finished) in
                    animationView.removeFromSuperview()
                }
            }
        }
        
        cell.saveMemoHandler = { text in
            lecture.memos[indexPath.item] = text
            self.viewModel.updateLec(lecture)
            self.viewModel.update(model: lecture)
            self.tableView.reloadData()
        }
        
        return cell
    }
}

extension DetailViewController {
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        let isLonger = tableView.frame.minY + tableView.bounds.height >= detailView.bounds.height - (keyboardViewEndFrame.height - view.safeAreaInsets.bottom)/2
        let isShorter = detailView.bounds.height - (keyboardViewEndFrame.height - view.safeAreaInsets.bottom)/2 >= tableView.frame.minY + tableView.bounds.height && tableView.frame.minY + tableView.bounds.height > detailView.bounds.height - (keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else if notification.name == UIResponder.keyboardWillShowNotification && isShorter {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardViewEndFrame.height - view.safeAreaInsets.bottom) * 3 / 4, right: 0)
        } else if notification.name == UIResponder.keyboardWillShowNotification && isLonger {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

class checkLecture: UITableViewCell {
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var firstBar: UIView!
    @IBOutlet weak var secondBar: UIView!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var saveMemoHandler: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.delegate = self
        firstBar.backgroundColor = buttonColorForDarkMode
        secondBar.backgroundColor = buttonColorForDarkMode
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        doneButton.isSelected = !doneButton.isSelected
        let isTapped = doneButton.isSelected
        doneButtonTapHandler?(isTapped)
    }
    
    @IBAction func memoAdded(_ sender: Any) {
        if inputTextField.text != nil {
            saveMemoHandler?(inputTextField.text!)
        }
    }
    
    func updateUI(_ lec: LectureInfo, _ idx: Int){
        doneButton.isSelected = lec.isDone[idx]
        inputTextField.text = lec.memos[idx]
    }
}

extension checkLecture: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.inputTextField.resignFirstResponder()
        return true
    }
}
