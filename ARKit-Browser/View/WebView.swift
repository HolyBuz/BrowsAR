import WebKit

protocol WebViewDelegate: class {
    func disableBackButton()
}

class WebView: UIView, UITextFieldDelegate, WKNavigationDelegate{
  
  private let webView = WKWebView()
  private let webViewNavigationBar = WebViewNavigationBar()

  let webViewNode: WebViewNode
  weak var delegate: WebViewDelegate?
  
  init(node: WebViewNode) {
    webViewNode = node
    
    super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 360, height: 480)))
    
    setupViews()
    setupHierarchy()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {

    webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
    webView.allowsBackForwardNavigationGestures = true
    
    webViewNavigationBar.delegate = self
    delegate = webViewNavigationBar
  }
  
  private func setupHierarchy() {
    addSubview(webViewNavigationBar)
    addSubview(webView)
  }
  
  private func setupLayout() {
    webViewNavigationBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webViewNavigationBar.topAnchor.constraint(equalTo: topAnchor),
      webViewNavigationBar.leftAnchor.constraint(equalTo: leftAnchor),
      webViewNavigationBar.rightAnchor.constraint(equalTo: rightAnchor),
      webViewNavigationBar.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      webView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
      webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}

extension WebView: WebViewNavigationBarDelegate {
  func didTapCLose() {
    removeFromSuperview()
    webViewNode.removeFromParentNode()
  }
  
  func didTapBack() {
    if webView.canGoBack {
      webView.goBack()
    } else {
      delegate?.disableBackButton()
    }
  }
  
  func didTapReturn(with urlRequest: URLRequest) {
    webView.load(urlRequest)
  }
}


