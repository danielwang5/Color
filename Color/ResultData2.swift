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

let answerList = [12,8,6,29,57]

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
    
    init(){
        
    }
}

struct PhoneData{
    var model: String = "Model Unknown"
    var brightness: Double = -1.0
    
    init(mod: String, bright:Double){
        model = mod
        brightness = bright
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
