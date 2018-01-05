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

extension Float { // add random capabilities for float
    private static let arc4randomMax = Float(UInt32.max)
    
    static func random01() -> Float {
        return Float(arc4random()) / arc4randomMax
    }
}

func rgbToLab(R:Double, G:Double, B:Double) -> [Double]{ // Convert RGB to CIE-LAB
    
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



func labTorgb(labL:Double, labA:Double, labB:Double) -> [Double] { // Convert CIE-LAB to RGB
    
    // D65/2°
    let Xr:Double = 95.047;
    let Yr:Double = 100.0;
    let Zr:Double = 108.883;
    
    // --------- Lab to XYZ --------- //
    
    var var_Y = ( labL + 16 ) / 116
    var var_X = labA / 500 + var_Y
    var var_Z = var_Y - labB / 200
    
    if ( pow(var_Y,3)  > 0.008856 ){var_Y = pow(var_Y,3)}
    else {var_Y = ( var_Y - 16 / 116 ) / 7.787}
    if ( pow(var_X,3)  > 0.008856 ){var_X = pow(var_X,3)}
    else {var_X = ( var_X - 16 / 116 ) / 7.787}
    if ( pow(var_Z,3)  > 0.008856 ){var_Z = pow(var_Z,3)}
    else {var_Z = ( var_Z - 16 / 116 ) / 7.787}
    
    let X = var_X * Xr
    let Y = var_Y * Yr
    let Z = var_Z * Zr
    
    // --------- XYZ to RGB --------- //
    
    var_X = X / 100
    var_Y = Y / 100
    var_Z = Z / 100
    
    var var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986
    var var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415
    var var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570
    
    if ( var_R > 0.0031308 ) {var_R = 1.055 * pow( var_R , ( 1 / 2.4 ) ) - 0.055}
    else {var_R = 12.92 * var_R}
    if ( var_G > 0.0031308 ) {var_G = 1.055 * pow( var_G , ( 1 / 2.4 ) ) - 0.055}
    else {var_G = 12.92 * var_G}
    if ( var_B > 0.0031308 ) {var_B = 1.055 * pow( var_B , ( 1 / 2.4 ) ) - 0.055}
    else {var_B = 12.92 * var_B}
    
    let sR = var_R * 255
    let sG = var_G * 255
    let sB = var_B * 255
    
    return [sR, sG, sB]
}
