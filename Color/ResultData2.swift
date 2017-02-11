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
    let questionId: Int
    let correctAnswer: Int
    let submittedAnswer: Int
    let orderInGame: Int
    let correct: Bool
    
    init(orderinGam: Int, quesId: Int, submittedAns: Int) {
        questionId = quesId
        submittedAnswer = submittedAns
        orderInGame = orderinGam
        correctAnswer = answerList[quesId]
        correct = answerList[quesId] == submittedAns
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
