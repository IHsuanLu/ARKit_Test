//
//  ViewController.swift
//  Test
//
//  Created by 呂易軒 on 2018/4/22.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacer: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?

    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.scene = scene
        
        setGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    //若沒寫這個 會pop全螢幕
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //detect the touch (get position)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: .featurePoint)
        
        //if the ARKit donesn't find feature (地板太黑或是怎樣的)
        guard let hitFeature = results.last else { return }
        
        //if there is feature -> get its tramsform
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        //把position傳到func裡面
        placeRamp(position: hitPosition)
    }
    
    @IBAction func popViewBtnPressed(_ sender: UIButton) {
        
        let rampPickerVC = RampPicker(size: CGSize(width: 250, height: 500))
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        
        //for ramPicker to reference rampPlacer func
        rampPickerVC.rampPlacer = self
        
        present(rampPickerVC, animated: true, completion: nil)
        
        //從哪裡跳出來？
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    //get selected Ramp Name from Picker
    func onRampSelected( rampName: String){
        selectedRampName = rampName
    }
    
    
    //create node and pass in position
    func placeRamp(position: SCNVector3){
        if let rampName = selectedRampName{ //安全措施
            
            removeBtn.isHidden = false
            rotateBtn.isHidden = false
            upBtn.isHidden = false
            downBtn.isHidden = false
            
            let ramp = Ramp.getRampForName(rampName: rampName)
            selectedRamp = ramp //get selectedRamp
            ramp.position = position
            ramp.scale = SCNVector3Make(0.005, 0.005, 0.005) //default
            
            sceneView.scene.rootNode.addChildNode(ramp)
        }
    }
    
    func setGestureRecognizer(){ 
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
    }
    
    @objc func onLongPress(_ gesture: UILongPressGestureRecognizer){
        
        if let ramp = selectedRamp{
            if gesture.state == .ended{
                ramp.removeAllActions()
            } else if gesture.state == .began{
                
                // === check the reference
                if gesture.view === rotateBtn{
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                } else if gesture.view === upBtn{
                    let up = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(up)
                } else if gesture.view === downBtn{
                    let down = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(down)
                }
            }
        }
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        if let ramp = selectedRamp{
            ramp.removeFromParentNode()
            selectedRamp = nil
        }
    }
}
