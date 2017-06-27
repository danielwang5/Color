//
//  DigitParams.swift
//  Color
//
//  Created by James Wang on 5/17/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import Foundation

//String digit filter

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

//ORIGIN IS BOTTOM LEFT CORNER

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
        
        func sign(p1:Point, p2:Point, p3:Point) -> Double{
            return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
        }
        
        let v1 = vertices[0]
        let v2 = vertices[1]
        let v3 = vertices[2]
            
        let b1 = sign(p1: p, p2: v1, p3: v2) < 0.0
        let b2 = sign(p1: p, p2: v2, p3: v3) < 0.0
        let b3 = sign(p1: p, p2: v3, p3: v1) < 0.0
            
        return ((b1 == b2) && (b2 == b3))
        
        /*var p0 = vertices[0]
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
        
        return s > 0 && t > 0 && (s + t) < 2 * A * sign*/
    }
}

class Box:Shape{
    var origin:Point
    var width:Double = 0.0
    var height:Double = 0.0
    
    init(o:Point, w:Double, h:Double){
        origin = o
        width = w
        height = h
    }
    
    func within(p:Point) -> Bool{
        let diffX:Double = (p.x-origin.x)
        let diffY:Double = (p.y-origin.y)
        return 0 <= diffX && diffX < width && 0 <= diffY && diffY < height
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
        var angle01:Double = atan2(p.y - center.y, p.x - center.x)/(2*M_PI)
        if(angle01 < 0.0){
            angle01 += 1
        }
        return Circle(c: center,r: outer).within(p:p) && !Circle(c: center,r: inner).within(p:p) &&
            sectorBegin <= angle01 && angle01 < sectorEnd
    }
}

class Digit: Shape{ // a collection of shapes
    var shapeList:[Shape] = []
    
    init(value:Int){
        assert(0 <= value && value <= 9)
        switch value {
        case 0:
            shapeList = [Ring(c: Point(xx: 0.5,yy: 0.7),i: 0.1, o: 0.3, sB: 0.0, sE: 0.5),
                         Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.5, sE: 1.0),
                         Box(o: Point(xx: 0.2,yy: 0.3),w: 0.2,h: 0.4),
                         Box(o: Point(xx: 0.6,yy: 0.3),w: 0.2,h: 0.4)]
        case 1:
            shapeList = [Box(o: Point(xx: 0.4,yy: 0.0),w: 0.2,h: 1.0)]
        case 2:
            shapeList = [Ring(c: Point(xx: 0.5,yy: 0.7),i: 0.1, o: 0.3, sB: 0.0, sE: 0.5),
                         Box(o: Point(xx: 0.2,yy: 0.0),w: 0.6,h: 0.2),
                         Triangle(v1x: 0.2,v1y: 0.2,v2x: 0.4,v2y: 0.2,v3x: 0.6,v3y: 0.7),
                         Triangle(v1x: 0.4,v1y: 0.2,v2x: 0.6,v2y: 0.7,v3x: 0.8,v3y: 0.7)]
        case 3:
            shapeList = [Ring(c: Point(xx: 0.5,yy: 0.7),i: 0.1, o: 0.3, sB: 0.0, sE: 0.5),
                         Ring(c: Point(xx: 0.5,yy: 0.7),i: 0.1, o: 0.3, sB: 0.75, sE: 1.0),
                         Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.0, sE: 0.25),
                         Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.5, sE: 1.0)]
        case 4:
            shapeList = [Box(o: Point(xx: 0.2,yy: 0.4),w: 0.2,h: 0.6),
                         Box(o: Point(xx: 0.4,yy: 0.4),w: 0.2,h: 0.2),
                         Box(o: Point(xx: 0.6,yy: 0.0),w: 0.2,h: 1.0)]
        case 5:
            shapeList = [Box(o: Point(xx: 0.2,yy: 0.8),w: 0.6,h: 0.2),
                        Box(o: Point(xx: 0.2,yy: 0.5),w: 0.2,h: 0.3),
                        Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.0, sE: 0.4),
                        Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.6, sE: 1.0)]
        case 6:
            shapeList = [Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.0, sE: 1.0),
                         Triangle(v1x: 0.2,v1y: 0.3,v2x: 0.4,v2y: 0.3,v3x: 0.6,v3y: 1.0),
                         Triangle(v1x: 0.4,v1y: 0.3,v2x: 0.6,v2y: 1.0,v3x: 0.8,v3y: 1.0)]
        case 7:
            shapeList = [Box(o: Point(xx: 0.2,yy: 0.8),w: 0.6,h: 0.2),
                         Triangle(v1x: 0.4,v1y: 0.0,v2x: 0.6,v2y: 0.0,v3x: 0.6,v3y: 0.8),
                         Triangle(v1x: 0.6,v1y: 0.0,v2x: 0.8,v2y: 0.8,v3x: 0.6,v3y: 0.8)]
        case 8:
            shapeList = [Ring(c: Point(xx: 0.5,yy: 0.7),i: 0.1, o: 0.3, sB: 0.0, sE: 1.0),
                         Ring(c: Point(xx: 0.5,yy: 0.3),i: 0.1, o: 0.3, sB: 0.0, sE: 1.0)]
        case 9:
            shapeList = [Ring(c: Point(xx: 0.5,yy: 0.7),i: 0.1, o: 0.3, sB: 0.0, sE: 1.0),
                         Triangle(v1x: 0.8,v1y: 0.7,v2x: 0.6,v2y: 0.7,v3x: 0.4,v3y: 0.0),
                         Triangle(v1x: 0.6,v1y: 0.7,v2x: 0.4,v2y: 0.0,v3x: 0.2,v3y: 0.0)]
            
            
        default:
            shapeList = []
        }
    }
    
    func within(p: Point) -> Bool {
        for thing in shapeList{
            if thing.within(p: p){
                return true
            }
        }
        return false
    }
}

class Number: Shape{
    
 //1 or 2 digits
    
    var tens:Int = 0 // multi digit
    var ones:Int = 0
    
    
    var value:Int = -1
    init(val:Int){ //value from 0 to 99
        if(val >= 10){
            tens = Int(val/10)
            ones = val%10
        }
        value = val
    }
    
    func within(p: Point) -> Bool {
        if(value <= 9){
            return Digit(value: value).within(p: p)
        }
        else{// Digits occupy:
            //
            //  ### ###
            //  ### ###
            //  ### ###
            //
            if(p.y < 0.25 || p.y > 0.75){
                return false;
            }
            else if(p.x < 0.5){ //first digit (tens)
                return Digit(value: tens).within(p: Point(xx: p.x * 2, yy: p.y * 2 - 0.5))
            }
            else{ //second digit (ones)
                return Digit(value: ones).within(p: Point(xx: p.x * 2 - 1, yy: p.y * 2 - 0.5))
            }
        }
    }
}





