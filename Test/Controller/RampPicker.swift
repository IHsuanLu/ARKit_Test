//
//  RampPicker.swift
//  Test
//
//  Created by 呂易軒 on 2018/4/22.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import SceneKit

class RampPicker: UIViewController {
    
    var sceneView: SCNView!
    var size: CGSize!

    
    //we don't want retain circle
    weak var rampPlacer: RampPlacer!
    
    //pop over view
    init(size: CGSize){
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //******** a scene can hold one or more object(scene)
    //從root裡抓東西放到另一個scene
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(size)
        
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.addSubview(sceneView)
        
        
        //important for pop over view
        preferredContentSize = size
        
        
        //load scene - ramps (holder)
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        //handle tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        //set camera (把z軸去掉，但是看起來還是3D)
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        
        let pipe = Ramp.getPipe()
        Ramp.startRotation(node: pipe)
        scene.rootNode.addChildNode(pipe)
        
        let pyramid = Ramp.getPyramid()
        Ramp.startRotation(node: pyramid)
        scene.rootNode.addChildNode(pyramid)
        
        let quarter = Ramp.getQuarter()
        Ramp.startRotation(node: quarter)
        scene.rootNode.addChildNode(quarter)
    }
    
    //addGestureRecognizer to whole screen then deal with each one accordingly
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer){
        
        //for 分辨你在那個View裡面按了哪裡
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        //see if anything is hit
        if hitResults.count > 0 {
            //grab the note that we hit
            let nodeIsHit = hitResults[0].node
            print(nodeIsHit.name!)
            rampPlacer.onRampSelected(rampName: nodeIsHit.name!)  //回傳誰在被點到RampPlacer
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
