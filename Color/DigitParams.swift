//
//  DigitParams.swift
//  Color
//
//  Created by James Wang on 5/17/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import Foundation

class DigitParams{
    
}

class Point{
    var x:Double
    var y:Double
    
    init(xx:Double, yy:Double){
        x = xx
        y = yy
    }
}

protocol Shape{
    func within(p:Point) -> Bool
}

class Triangle: Shape{
    var vertices:[Point] //between 0.0 and 1.0
    
    init(v:[Point]){
        vertices = v
    }
    
    init(v1x:Double, v1y:Double, v2x:Double, v2y:Double, v3x:Double, v3y:Double){
        vertices = [Point(xx: v1x,yy: v1y), Point(xx: v2x,yy: v2y), Point(xx: v3x,yy: v3y)]
    }
    
    func within(p:Point) -> Bool{
        
        var p0 = vertices[0]
        var p1 = vertices[1]
        var p2 = vertices[2]
        
        var A = 1/2 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y)
        var sign:Double = A < 0 ? -1 : 1
        var s1 = p0.y * p2.x - p0.x * p2.y
        var s2 = p2.y * p.x - p0.y * p.x
        var s3 = p0.x * p.y - p2.x * p.y
        var s = (s1 + s2 + s3) * sign
        var t1 = p0.x * p1.y - p0.y * p1.x
        var t2 = p0.y * p.x - p1.y * p.x
        var t3 = p1.x * p.y - p0.x * p.y
        var t = (t1 + t2 + t3) * sign
        
        return s > 0 && t > 0 && (s + t) < 2 * A * sign
    }
}

class Circle: Shape{
    
    var center: Point
    var radius: Double = 0.0
    
    init(c:Point, r:Double){
        center = c
        radius = r
    }
    
    func within(p:Point) -> Bool{
        return ((p.x - center.x) * (p.x - center.x) + (p.y - center.y) * (p.y - center.y)) <= (radius * radius)
    }
}

class Ring: Shape{
    var center: Point
    var inner: Double = 0.0
    var outer: Double = 0.0
    var sectorBegin: Double = 0.0 // zero to 1 -> 360 revolution
    var sectorEnd: Double = 1.0
    
    init(c:Point, i:Double, o:Double, sB:Double, sE:Double){
        center = c
        inner = i
        outer = o
        sectorBegin = sB
        sectorEnd = sE
    }
    
    func within(p:Point) -> Bool{
        let angle01:Double = atan2(p.y - center.y, p.x - center.x)/(2*M_PI)
        return Circle(c: center,r: outer).within(p:p) && !Circle(c: center,r: outer).within(p:p) &&
            sectorBegin <= angle01 && angle01 < sectorEnd
    }
}

class Digit: Shape{ // a collection of shapes
    var shapeList:[Shape] = []
    
    init(value:Int){
        assert(0 <= value && value <= 9)
        switch value {
        case 0:
            shapeList = []
        case 1:
            shapeList = [Triangle(v1x: 0.4,v1y: 0.0,v2x: 0.6,v2y: 0.0,v3x: 0.4,v3y: 1.0),
                         Triangle(v1x: 0.6,v1y: 0.0,v2x: 0.4,v2y: 1.0,v3x: 0.6,v3y: 1.0)]
        case 2:
            shapeList = []
        case 3:
            shapeList = []
        case 4:
            shapeList = []
        case 5:
            shapeList = []
        case 6:
            shapeList = []
        case 7:
            shapeList = []
        case 8:
            shapeList = []
        case 9:
            shapeList = []
            
            
        default:
            shapeList = []
        }
    }
    
    func within(p: Point) -> Bool {
        
    }
}





