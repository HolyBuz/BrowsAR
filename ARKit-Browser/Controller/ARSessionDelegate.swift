import ARKit

extension ViewController: ARSessionDelegate {
  // Update webView size and orientation at every update of ARKit
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    for view in webViewArray {
      let projectedPosition = self.sceneView.projectPoint(view.webViewNode.worldPosition)
      
      let size = view.frame.size
      let x = CGFloat(projectedPosition.x) - size.width/2
      let y = CGFloat(projectedPosition.y) - size.height/2
      
      view.frame.origin = CGPoint(x: x, y: y)
    }
  }
}
