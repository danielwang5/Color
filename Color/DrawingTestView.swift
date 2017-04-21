//
//  DrawingTestView.swift
//  Color
//
//  Created by James Wang on 3/22/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import Foundation
import UIKit




class DrawingTestView: UIView{
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        context?.setStrokeColor(color!)
        //context?.move(to: CGPoint(x: 100, y: 100))
        //context?.addLine(to: CGPoint(x: 100, y: 200))
        //context?.addLine(to: CGPoint(x: 200, y: 200))
        context?.strokePath()
        
        
        
        //self.layer.addSublayer(createCircle(x: 100, y: 100, radius: 50, color: UIColor.blue.cgColor))
        
        
        /*******   CIRCLE GENERATION BEGIN   *******/
        
        
        let MIN_R:Double = 1;
        let MAX_R:Double = 12;
        
        // canvas size
        let WIDTH:Int  = 600;
        let HEIGHT:Int = 600;
        let SIZE = WIDTH * HEIGHT;
        
        // buffer for store ineligible positions of circles
        //var buffer =  new ArrayBuffer(SIZE);
        //var area   = new Int8Array(buffer);
        
        var area = [Int](repeating: 0, count:SIZE)
        
        // chunk size
        let CHUNK_SIZE = MAX_R * 2;
        let CHUNK_COLS = Int(ceil(Double(WIDTH)  / Double(CHUNK_SIZE)))
        let CHUNK_ROWS = Int(ceil(Double(HEIGHT) / Double(CHUNK_SIZE)))
        
        var chunks:[[[Circle]]] = []
        
        
        // point obj
        struct Point {
            var x:Double = 0
            var y:Double = 0
            init(x1:Double, y1:Double){
                x = x1
                y = y1
            }
        }
        
        // circle obj
        
        struct Circle {
            
            var x:Double = 0
            var y:Double = 0
            var radius:Double = -1
            
            init(x1:Double, y1:Double, radius1:Double){
                x = x1
                y = y1
                radius = radius1
            }
            
            
        }
        
        func show(circ:Circle){
            //fill(random(0, 255)); RANDOM COLOR??
            createCircle(x: CGFloat(circ.x), y: CGFloat(circ.y), radius: CGFloat(circ.radius*2), color: UIColor.blue.cgColor)
        }
        
        // index to coordinate
        func getPos(index:Int) -> Point {
            return Point(x1: Double(index % WIDTH), y1: Double(index / WIDTH));
        }
        
        // coordinate to index
        func getIndex(x:Int, y:Int) -> Int {
            return x + y * WIDTH;
        }
        
        // select chunk that corresponds to the coordinates
        func getChunk(x:Double, y:Double) -> [Int] {
            return [
                Int(x / (CHUNK_SIZE)),
                Int(y / (CHUNK_SIZE))
            ]
        }
        
        // select neighbor chunks
        func getNeighborChunks(row:Int, col:Int) -> [[Circle]]{
            var result:[[Circle]] = []
            
            result.append(chunks[row][col]);
            
            if (col > 0) {
                result.append(chunks[row][col - 1]);
                
                if (row > 0) {
                    result.append(chunks[row - 1][col - 1]);
                }
            }
            if (col < CHUNK_COLS - 1) {
                result.append(chunks[row][col + 1]);
                
                if (row < CHUNK_ROWS - 1) {
                    result.append(chunks[row + 1][col + 1]);
                }
            }
            if (row > 0) {
                result.append(chunks[row - 1][col]);
                
                if (col < CHUNK_COLS - 1) {
                    result.append(chunks[row - 1][col + 1]);
                }
            }
            if (row < CHUNK_ROWS - 1) {
                result.append(chunks[row + 1][col]);
                
                if (col > 0) {
                    result.append(chunks[row + 1][col - 1]);
                }
            }
            
            return result;
        }
        
        // random integer
        func getRandomInt(min:Int, max:Int) -> Int{
            return Int(random01() * Double(max - min)) + min;
        }
        
        func getRandomDouble(min:Double, max:Double) -> Double{
            return random01() * (max - min) + min;
        }
        
        func random01() -> Double{
            return Double(arc4random()) / Double(UINT32_MAX)
        }
        
        
        func dist(x1:Double,y1:Double,x2:Double,y2:Double) -> Double{
            return sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))
        }
        
        // get random from possible radius of the circle in spicified position
        // or return false if the circle can not be placed in this position
        func getRadius(x:Double, y:Double) -> Double{
            
            var chunk     = getChunk(x: x, y: y);
            var neighbors = getNeighborChunks(row: chunk[0], col: chunk[1]);
            
            // distance to nearest circle
            var max = MAX_R;
            
            // for each circle in neighbors chunks
            for i in 0..<neighbors.count{
                for j in 0..<neighbors.count{
                    
                    var circle = neighbors[i][j];
                    // distance to the circle edge
                    var r = dist(x1: x, y1: y, x2: circle.x, y2: circle.y) - circle.radius;
                    
                    if (r < max) {
                        max = r;
                    }
                    
                    if (max < MIN_R) {
                        // circle can not be placed in this position
                        return -1.0;
                    }
                }
            }
            
            if(max > MAX_R) {
                max = MAX_R;
            }
            
            // return max;
            // return random(MIN_R, max);
            return constrain(val: getRandomDouble(min: MIN_R, max: MAX_R), lower: MIN_R, upper: max);
        }
        
        let SQRT:Double = 1 / sqrt(2);
        // disallow positions in area under the circle
        func reduceArea(circle:Circle) {
            var size = round((circle.radius + MIN_R - 1) * SQRT);
            
            var beginX = constrain(val: circle.x - size, lower: 0, upper: Double(WIDTH));
            var beginY = constrain(val: circle.y - size, lower: 0, upper: Double(HEIGHT));
            var endX   = constrain(val: circle.x + size, lower: 0, upper: Double(WIDTH));
            var endY   = constrain(val: circle.y + size, lower: 0, upper: Double(HEIGHT));
            
            var length = endX - beginX;
            var index  = getIndex(x: Int(beginX), y: Int(beginY));
            for y in Int(beginY)...Int(endY){
                //area.fill(1, index, index + length);
                index += WIDTH;
            }
        }
        
        func constrain(val:Double, lower:Double, upper:Double) -> Double {
            return min(max(val,lower),upper)
        }
        
        func setup() {
            //createCanvas(WIDTH, HEIGHT);
            
            //stroke('black');
            //strokeWeight(1);
            
            // create chunks
            for j in 0 ..< CHUNK_ROWS {
                chunks.append([[Circle]]())
                for i in 0 ..< CHUNK_COLS {
                    chunks[j].append([Circle]())
                }
            }
            
            for i in 1...200 {
                generate()
            }
        }
        
        // generate circles
        func generate() {
            var index:Int
            // get random allowable position
            repeat {
                index = getRandomInt(min: 0, max: SIZE);
            } while(area[index] == 1);
            
            
            var center = getPos(index: index);
            
            var radius = getRadius(x: center.x, y: center.y);
            
            if(radius >= 0.0) {
                var circle = Circle(x1: Double(center.x), y1: center.y, radius1: radius);
                var chunk  = getChunk(x: center.x, y: center.y);
                
                // put a circle in the corresponding chunk
                chunks[chunk[0]][chunk[1]].append(circle);
                
                reduceArea(circle: circle);
                
                show(circ: circle);
            }
            else {
                // because circle cannot be placed in this position
                // let's disallow this for subsequent checks
                area[index] = -1;
            }
        }
        
        
        //RUN!!!!!
        
        setup()
        generate()
        
        
        /*******   CIRCLE GENERATION END *******/
        
        
        
    }
    
    func createCircle(x:CGFloat, y:CGFloat, radius:CGFloat, color:CGColor) -> CAShapeLayer{ //Circle graphic
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: x,y: y), radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = color
        //you can change the stroke color
        //shapeLayer.strokeColor = color
        //you can change the line width
        shapeLayer.lineWidth = 0.0
    
        return shapeLayer
    }
    
    
}