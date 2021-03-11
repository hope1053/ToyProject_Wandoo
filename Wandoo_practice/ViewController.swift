//
//  ViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func unwind(_ segue: UIStoryboardSegue){
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            if let index = sender as? Int {
                let lecInfo = viewModel.lectureInfo(at: index)
                vc?.viewModel.update(model: lecInfo)
            }
        }
    }
    
    let viewModel = MainViewModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numoflectureList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else{
            return UITableViewCell()
        }
        let lecture = viewModel.lectureInfo(at: indexPath.row)
        cell.updateUI(info: lecture)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    @IBAction func getInfo(_ sender: Any) {
        performSegue(withIdentifier: "getInfo", sender: nil)
    }
    
    
}

class ListCell: UITableViewCell {
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    func updateUI(info: LectureInfo){
        lectureLabel.text = info.name
        dateLabel.text = info.date
        numLabel.text = "\(info.numoflec)"
    }
    
}

class MainViewModel {
    let lectureList: [LectureInfo] = [LectureInfo(name:"파이썬 웹 개발 올인원 패키지",date:"2021.01.09~",numoflec:10),LectureInfo(name:"코딩 첫걸음 프로젝트 올인원 패키지",date:"2021.01.02~",numoflec:5),LectureInfo(name:"누구나 가능한 VR/AR 콘텐츠 제작 ",date:"2021.01.21~",numoflec:20),LectureInfo(name:"생존을 위한 IT 필수지식 ",date:"2021.01.14~",numoflec:30),LectureInfo(name:"디지털 마케팅 MAX ",date:"2021.01.31~",numoflec:18)]
    
    var numoflectureList: Int {
        return lectureList.count
    }
    
    func lectureInfo(at index:Int) -> LectureInfo {
        return lectureList[index]
    }
}
