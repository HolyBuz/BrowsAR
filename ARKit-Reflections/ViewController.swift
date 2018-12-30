//
//  ViewController.swift
//  ARKit-Reflections
//
//  Created by Alessandro Loi on 30/12/2018.
//  Copyright © 2018 Alessandro Loi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // Object Model
    var objectModel : SCNNode = {
        
        //let sphereNode = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.1) )
        let reflectionMaterial = SCNMaterial()
        reflectionMaterial.isDoubleSided = true
        reflectionMaterial.lightingModel = .physicallyBased
        reflectionMaterial.metalness.contents = 1.0
        reflectionMaterial.roughness.contents = 0.0
        
        sphereNode.geometry?.firstMaterial = reflectionMaterial
        
        return sphereNode
    }()
    
    // Tap Gesture Recognizer callback
    @objc func tapped(sender : UITapGestureRecognizer)
    {
        let touchLocation = sender.location(in: sceneView)
        
        if let hitTestResult = sceneView.smartHitTest(touchLocation)
        {
            // Giving the object the translation of the smart hit test
            objectModel.simdPosition = float3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
            
            // Object always looking at the camera
            let billboardConstraints = SCNBillboardConstraint()
            billboardConstraints.freeAxes = .all
            objectModel.constraints = [billboardConstraints]
            
            // Adding the object to the scene
            self.sceneView.scene.rootNode.addChildNode(objectModel)
            
        }
        
    }
    
    func setUpGestureRecognizer()
    {
        //Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped) )
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setUpScene()
    {
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScene()
        
        setUpGestureRecognizer()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.setUpConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ARSCNView
{
    // Apple's smart hit test
    func smartHitTest(_ point: CGPoint) -> ARHitTestResult? {
        
        // Perform the hit test.
        let results = hitTest(point, types: [.existingPlaneUsingGeometry])
        
        // 1. Check for a result on an existing plane using geometry.
        if let existingPlaneUsingGeometryResult = results.first(where: { $0.type == .existingPlaneUsingGeometry }) {
            return existingPlaneUsingGeometryResult
        }
        
        // 2. Check for a result on an existing plane, assuming its dimensions are infinite.
        let infinitePlaneResults = hitTest(point, types: .existingPlane)
        
        if let infinitePlaneResult = infinitePlaneResults.first {
            return infinitePlaneResult
        }
        
        // 3. As a final fallback, check for a result on estimated planes.
        return results.first(where: { $0.type == .estimatedHorizontalPlane })
    }
    
    //Set Up New configuration
    func setUpConfiguration()
    {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.environmentTexturing = .automatic
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        self.session.run(configuration)
    }
    
}

