// Playground - noun: a place where people can play

import XCPlayground
import Cocoa

let red = CGFloat(Int(arc4random_uniform(255))) / 255.0
let green = CGFloat(Int(arc4random_uniform(255))) / 255.0
let blue = CGFloat(Int(arc4random_uniform(255))) / 255.0

let randomCGColor = CGColorCreateGenericRGB(red, green, blue, 1.0)
let color = NSColor(CGColor: randomCGColor)


//XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
