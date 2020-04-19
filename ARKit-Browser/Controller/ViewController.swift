import ARKit

class ViewController: UIViewController {
  
  @IBOutlet var sceneView: ARSCNView!
  
  var webViewArray : [WebView] = []
  
  private lazy var restartSessionButton : UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "restart_icon.png"), for: UIControl.State.normal)
    button.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpScene()
    setUpGestureRecognizer()
    setUpRestartSessionButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sceneView.setUpNewTrackingConfiguration()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
}

//MARK:- SetUps
extension ViewController {
  func setUpGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap) )
    sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func setUpScene() {
    let scene = SCNScene()
    sceneView.scene = scene
    sceneView.session.delegate = self
  }
  
  func setUpRestartSessionButton() {
    view.addSubview(restartSessionButton)
    
    restartSessionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      restartSessionButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
      restartSessionButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 30),
      restartSessionButton.widthAnchor.constraint(equalToConstant: 30),
      restartSessionButton.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
}

extension ViewController {
  
  @objc func didTap(sender : UITapGestureRecognizer) {
    // Grabbing the camera current Transform
    guard let cameraCurrentTransform = self.sceneView.session.currentFrame?.camera.transform else { return }
    
    let node = WebViewNode()
    
    var translation = matrix_identity_float4x4
    translation.columns.3 = simd_float4(x: 0, y: 0, z: -1, w: translation.columns.3.w)
    
    // Assegning the result to the node's simdTransform
    node.simdTransform = matrix_multiply(cameraCurrentTransform, translation)
    
    // Adding the object to the scene
    sceneView.scene.rootNode.addChildNode(node)
    
    // Adding the web view to the sceneView
    let webView = WebView(node: node)
    view.addSubview(webView)
    
    // Appending the view to the array
    webViewArray.append(webView)
  }
  
  @objc func didTapRefresh() {
    webViewArray.removeAll()
    
    view.subviews.filter{$0 is WebView}.forEach { $0.removeFromSuperview() }
    
    self.sceneView.scene.rootNode.enumerateChildNodes { (node, _ ) in
      node.removeFromParentNode()
    }
  }
}



