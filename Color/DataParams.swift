//
//  ResultData2.swift
//  Color
//
//  Created by James Wang on 2/9/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

//NON PERSISTENT

import Foundation
import UIKit

let answerList = [12,8,6,29,57,5,3,15,74,2,6,97,45,5,7,16,73]

struct SubmittedDataModified{
    var correctAnswer: Int = -1
    var submittedAnswer: Int = -1
    var orderInGame: Int = -1
    var correct: Bool = false
    var timeElapsed: Double = -1.0
    var phoneInfo: PhoneData = PhoneData()
    
    var numberColorR:Int = -1
    var numberColorG:Int = -1
    var numberColorB:Int = -1
    var backgroundColorR:Int = -1
    var backgroundColorG:Int = -1
    var backgroundColorB:Int = -1

    
    init(phoneInf: PhoneData, orderinGam: Int, correctAns: Int, submittedAns: Int, timeElapse: Double, numCol: [Int], backCol:[Int]) {
        phoneInfo = phoneInf
        submittedAnswer = submittedAns
        orderInGame = orderinGam
        correctAnswer = correctAns
        correct = correctAns == submittedAns
        timeElapsed = timeElapse
        numberColorR = numCol[0]
        numberColorG = numCol[1]
        numberColorB = numCol[2]
        backgroundColorR = backCol[0]
        backgroundColorG = backCol[1]
        backgroundColorB = backCol[2]
    }
    
    func toString() -> String{
        return String(correctAnswer)+","+String(submittedAnswer)+","+String(orderInGame)+","+String(correctAnswer)+","+String(correct)+","+String(timeElapsed)+","+String(phoneInfo.phoneId)+","+String(phoneInfo.model)+","+String(phoneInfo.brightness)+","+String(numberColorR)+","+String(numberColorG)+","+String(numberColorB)+","+String(backgroundColorR)+","+String(backgroundColorG)+","+String(backgroundColorB)
        
    }
    
    init(){
        
    }
}

struct SubmittedData{
    var questionId: Int = -1
    var correctAnswer: Int = -1
    var submittedAnswer: Int = -1
    var orderInGame: Int = -1
    var correct: Bool = false
    var timeElapsed: Double = -1.0
    var phoneInfo: PhoneData = PhoneData()
    
    init(phoneInf: PhoneData, orderinGam: Int, quesId: Int, submittedAns: Int, timeElapse: Double) {
        phoneInfo = phoneInf
        questionId = quesId
        submittedAnswer = submittedAns
        orderInGame = orderinGam
        correctAnswer = answerList[quesId]
        correct = answerList[quesId] == submittedAns
        timeElapsed = timeElapse
    }
    
    func toString() -> String{
        return String(questionId)+","+String(correctAnswer)+","+String(submittedAnswer)+","+String(orderInGame)+","+String(correctAnswer)+","+String(correct)+","+String(timeElapsed)+","+String(phoneInfo.phoneId)+","+String(phoneInfo.model)+","+String(phoneInfo.brightness)
        
    }
    
    init(){
        
    }
}

struct PhoneData{
    var model: String = "Model Unknown"
    var brightness: Double = -1.0
    var phoneId: String = "Phone Id Unknown"
    
    init(id: String, mod: String, bright:Double){
        model = mod
        brightness = bright
        phoneId = id
    }
    
    init(){
        
    }
}

class ResultData2 {
    var data: [SubmittedData]
    
    init() {
        self.data = []
    }
    
    init(dat: [SubmittedData]){
        self.data = dat
    }
    
    func setAns(info: SubmittedData){
        self.data.append(info)
    }
}
