import UIKit

protocol WebViewNavigationBarDelegate: class {
  func didTapCLose()
  func didTapBack()
  func didTapReturn(with urlRequest: URLRequest)
}

class WebViewNavigationBar: UIView {
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "closeButton.png"), for: .normal)
    button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    return button
  }()
  
  private lazy var textField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = UIColor.white
    textField.textColor = .black
    textField.placeholder = "Search"
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  weak var delegate: WebViewNavigationBarDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupHierarchy()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    
    textField.delegate = self
    backgroundColor = UIColor.gray
  }
  
  private func setupHierarchy() {
    addSubview(textField)
    addSubview(backButton)
    addSubview(closeButton)
  }
  
  private func setupLayout() {
    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.leftAnchor.constraint(equalTo: leftAnchor),
      backButton.topAnchor.constraint(equalTo: topAnchor),
      backButton.bottomAnchor.constraint(equalTo: bottomAnchor),
      backButton.widthAnchor.constraint(equalToConstant: 50)
    ])
    
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      closeButton.widthAnchor.constraint(equalToConstant: 50),
      closeButton.topAnchor.constraint(equalTo: topAnchor, constant: -20),
      closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
      closeButton.rightAnchor.constraint(equalTo: rightAnchor)
    ])
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 10),
      textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      textField.widthAnchor.constraint(equalToConstant: 240)
    ])
  }

  @objc func goBack() {
    delegate?.didTapBack()
  }

  @objc func closeView() {
    delegate?.didTapCLose()
  }
}

extension WebViewNavigationBar: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text, let url = URL(string: "https://www.google.com/search?q=" + text) {
      let urlRequest = URLRequest(url: url)
      delegate?.didTapReturn(with: urlRequest)
      backButton.isEnabled = true
    }
    
    textField.resignFirstResponder()
    return true
  }
}

extension WebViewNavigationBar: WebViewDelegate {
  func disableBackButton() {
    backButton.isHidden = false
  }
}


