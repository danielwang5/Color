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

func rgbToLab(R:Double, G:Double, B:Double) -> [Double]{
    
    var r, g, b, X, Y, Z, xr, yr, zr:Double
    
    // D65/2°
    let Xr:Double = 95.047;
    let Yr:Double = 100.0;
    let Zr:Double = 108.883;
    
    
    // --------- RGB to XYZ ---------//
    
    r = R/255.0;
    g = G/255.0;
    b = B/255.0;
    
    if (r > 0.04045){
        r = pow((r+0.055)/1.055,2.4);
    }
    else{
        r = r/12.92
    }
    
    if (g > 0.04045){
        g = pow((g+0.055)/1.055,2.4);
    }
    else{
        g = g/12.92
    }
    
    if (b > 0.04045){
        b = pow((b+0.055)/1.055,2.4)
    }
    else{
        b = b/12.92
    }
    
    r*=100;
    g*=100;
    b*=100;
    
    X =  0.4124*r + 0.3576*g + 0.1805*b;
    Y =  0.2126*r + 0.7152*g + 0.0722*b;
    Z =  0.0193*r + 0.1192*g + 0.9505*b;
    
    
    // --------- XYZ to Lab --------- //
    
    xr = X/Xr;
    yr = Y/Yr;
    zr = Z/Zr;
    
    if ( xr > 0.008856 ){
        xr =  pow(xr, 1/3.0)
    }
    else{
        xr = ((7.787 * xr) + 16 / 116.0);
    }
    
    if ( yr > 0.008856 ){
        yr = pow(yr, 1/3.0);
    }
    else{
        yr = ((7.787 * yr) + 16 / 116.0);
    }
    
    if ( zr > 0.008856 ){
        zr =  pow(zr, 1/3.0);
    }
    else{
        zr = ((7.787 * zr) + 16 / 116.0);
    }
    
    
    var lab:[Double] = [0,0,0];
    
    lab[0] = (116*yr)-16;
    lab[1] = 500*(xr-yr);
    lab[2] = 200*(yr-zr);
    
    return lab;
    
}
