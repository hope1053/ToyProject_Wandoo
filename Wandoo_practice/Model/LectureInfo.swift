//
//  LectureInfo.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/28.
//

import UIKit

struct LectureInfo: Codable, Equatable {
    let id: Int
    var name: String
    var date: String
    var numOfLec: String
    var doneNumOfLec: Int
    var isDone: [Bool]
    var memos: [String]
    
    mutating func update(name: String, date: String, numOfLec: String, isDone: [Bool], doneNumOfLec: Int, memos: [String]) {
        self.name = name
        self.date = date
        self.numOfLec = numOfLec
        self.isDone = isDone
        self.doneNumOfLec = doneNumOfLec
        self.memos = memos
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class LectureManager {
    static let shared = LectureManager()

    static var lastId: Int = 0

    var lectures: [LectureInfo] = []

    func createLecture(name: String, date: String, numOfLec: String) -> LectureInfo {
        let nextId = LectureManager.lastId + 1
        LectureManager.lastId = nextId
        let selectedArr = [Bool](repeating: false, count: Int(numOfLec)!)
        let memoArr = [String](repeating: "", count: Int(numOfLec)!)
        return LectureInfo(id: nextId, name: name, date: date, numOfLec: numOfLec, doneNumOfLec: 0, isDone: selectedArr, memos: memoArr)
    }
    
    func updateLec(_ lec: LectureInfo) {
        guard let index = lectures.firstIndex(of: lec) else { return }
        let numOfTrue = lec.isDone.filter{$0}.count
        lectures[index].update(name: lec.name, date: lec.date, numOfLec: lec.numOfLec, isDone: lec.isDone, doneNumOfLec: numOfTrue, memos: lec.memos)
        saveLec()
    }
    
    func addLec(_ lec: LectureInfo) {
        lectures.append(lec)
        saveLec()
    }

    func deleteLec(_ lec: LectureInfo) {
        lectures = lectures.filter { $0.id != lec.id }
        saveLec()
    }
    
    func reviseLec(_ lec: LectureInfo) -> LectureInfo {
        var newLec: LectureInfo = lec
        newLec.numOfLec = lec.numOfLec
        if Int(newLec.numOfLec)! > newLec.isDone.count {
            newLec.isDone += [Bool](repeating: false, count: Int(newLec.numOfLec)! - newLec.isDone.count)
            newLec.memos += [String](repeating: "", count: Int(newLec.numOfLec)! - newLec.memos.count)
        } else if Int(newLec.numOfLec)! < newLec.isDone.count {
            newLec.isDone = Array(lec.isDone[0..<Int(newLec.numOfLec)!])
            newLec.memos = Array(lec.memos[0..<Int(newLec.numOfLec)!])
        }
        return newLec
    }

    func saveLec() {
        Storage.store(lectures, to: .documents, as: "lectures.json")
    }

    // 디스크에 썼던 내용을 실제로 메모리에 올리는 과정
    func retrieveLec() {
        lectures = Storage.retrive("lectures.json", from: .documents, as: [LectureInfo].self) ?? []
        let lastId = lectures.last?.id ?? 0
        LectureManager.lastId = lastId
    }
}

class DetailViewModel {
    var lecInfo: LectureInfo?
    
    func update(model: LectureInfo?) {
        lecInfo = model
    }
    
    private let manager = LectureManager.shared

    var lectures: [LectureInfo] {
        return manager.lectures
    }

    var numOfLec: Int{
        return lectures.count
    }

    func addLec(_ lec: LectureInfo) {
        manager.addLec(lec)
    }

    func deleteLec(_ lec: LectureInfo) {
        manager.deleteLec(lec)
    }

    func loadTasks() {
        manager.retrieveLec()
    }
    
    func updateLec(_ lec: LectureInfo) {
        manager.updateLec(lec)
    }
    
    func reviseLec(_ lec: LectureInfo) -> LectureInfo {
        return manager.reviseLec(lec)
    }
}
