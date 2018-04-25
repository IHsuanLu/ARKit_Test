//
//  Ramp.swift
//  Test
//
//  Created by 呂易軒 on 2018/4/23.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation
import SceneKit

//class func is static!
class Ramp {
    
    //get the ramp by passing the name
    //也可以用if else做
    class func getRampForName(rampName: String) -> SCNNode{
        
        switch rampName{
        case "pipe":
            return Ramp.getPipe()
        case "pyramid":
            return Ramp.getPyramid()
        case "quarter":
            return Ramp.getQuarter()
        default:
            return Ramp.getPipe()
        }
        
    }
    
    //load Ramp (.dae)
    class func getPipe() -> SCNNode{
        
        //grabbing the entire scene
        let obj = SCNScene(named: "art.scnassets/pipe.dae")
        //grab the node outta scene
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)
        node?.scale = SCNVector3Make(0.0028, 0.0028, 0.0028)  //大小
        node?.position = SCNVector3Make(-1, 0.7, -1) //位置
        //throw it into scene
        return node!
    }
    
    class func getPyramid() -> SCNNode{
        
        let obj2 = SCNScene(named: "art.scnassets/pyramid.dae")
        let node2 = obj2?.rootNode.childNode(withName: "pyramid", recursively: true)
        node2?.scale = SCNVector3Make(0.0068, 0.0068, 0.0068)
        node2?.position = SCNVector3Make(-1, -0.45, -1)
        return node2!
    }
    
    class func getQuarter() -> SCNNode{
        
        let obj3 = SCNScene(named: "art.scnassets/quarter.dae")
        let node3 = obj3?.rootNode.childNode(withName: "quarter", recursively: true)
        node3?.scale = SCNVector3Make(0.0068, 0.0068, 0.0068)
        node3?.position = SCNVector3Make(-1, -2.2, -1)
        return node3!
    }
    
    class func startRotation(node: SCNNode){
        //set rotate
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
        
        node.runAction(rotate)
    }
}
