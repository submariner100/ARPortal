//
//  ViewController.swift
//  ARPortal
//
//  Created by Macbook on 10/11/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

     @IBOutlet weak var sceneView: ARSCNView!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          sceneView.delegate = self
     }
     
     override func viewWillAppear(_ animated: Bool) {
          
          let configuration = ARWorldTrackingConfiguration()
          configuration.planeDetection = .horizontal
          sceneView.session.run(configuration)
     }
     
     override func viewWillDisappear(_ animated: Bool) {
          sceneView.session.pause()
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          if let touch = touches.first {
               let touchLocation = touch.location(in: sceneView)
               let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
               if let hitResults = results.first {
               
                    let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
                    if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true) {
                         
                         boxNode.position = SCNVector3(x:
                              hitResults.worldTransform.columns.3.x, y:
                              hitResults.worldTransform.columns.3.y + 0.05, z:
                              hitResults.worldTransform.columns.3.z)
                         
                         sceneView.scene.rootNode.addChildNode(boxNode)
                         
                    }
               }
          }
     }
     
     func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
          if anchor is ARPlaneAnchor {
               let planeAnchor = anchor as! ARPlaneAnchor
               let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
               
               let planeNode = SCNNode()
               planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
               //when a plane is created it is in the xy posn we need to rotate it
               //into the xz position
               planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
               
               let gridMaterial = SCNMaterial()
               gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
               plane.materials = [gridMaterial]
               
               planeNode.geometry = plane
               node.addChildNode(planeNode)
               
          } else {
               
               return
          }
     }

}

