//
//  ColorGeneration.swift
//  Color
//
//  Created by James Wang on 7/13/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import Foundation

class ColorGeneration{
    let initialDifference:Float = 1.0
    let multiplier:Float = 0.9
    
    func getColors(iteration:Int) -> [[Float]]{ //iteration starting from 0
        let difference = initialDifference * pow(multiplier,Float(iteration))
        
        var background:[Float] = [0,0,0]
        var number:[Float] = [0,0,0]
        
        var r1 = Float.random01()
        var r2 = Float.random01()
        var r3 = Float.random01()
        
        r1 = r1/(r1+r2+r3)*difference
        r2 = r2/(r1+r2+r3)*difference
        r3 = r3/(r1+r2+r3)*difference
        
        //random + or -
        r1 *= (Float.random01() > 0.5) ? 1 : -1
        r2 *= (Float.random01() > 0.5) ? 1 : -1
        r3 *= (Float.random01() > 0.5) ? 1 : -1
        
        if(r1 > 0){
            background[0] = Float.random01() * (1-r1)
            number[0] = background[0] + r1
        }
        else{
            r1 = -r1
            background[0] = Float.random01() * (1-r1) + (r1)
            number[0] = background[0] - r1
        }
        if(r2 > 0){
            background[1] = Float.random01() * (1-r2)
            number[1] = background[1] + r2
        }
        else{
            r2 = -r2
            background[1] = Float.random01() * (1-r2) + (r2)
            number[1] = background[1] - r2
        }
        if(r3 > 0){
            background[2] = Float.random01() * (1-r3)
            number[2] = background[2] + r3
        }
        else{
            r3 = -r3
            background[2] = Float.random01() * (1-r3) + (r3)
            number[2] = background[2] - r3
        }
        
        background[0] = min(1,max(0,background[0]))
        background[1] = min(1,max(0,background[1]))
        background[2] = min(1,max(0,background[2]))
        number[0] = min(1,max(0,number[0]))
        number[1] = min(1,max(0,number[1]))
        number[2] = min(1,max(0,number[2]))
        
        return [background, number]
    }
}

extension Float {
    private static let arc4randomMax = Float(UInt32.max)
    
    static func random01() -> Float {
        return Float(arc4random()) / arc4randomMax
    }
}
