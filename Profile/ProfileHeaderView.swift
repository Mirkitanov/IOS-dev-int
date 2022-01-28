
import UIKit

class ProfileHeaderView: UIView {
    
    // MARK: Properties
    
    @IBOutlet private var avatarImageView: UIImageView! {
        didSet {
            setupImageView()
        }
    }
    
    @IBOutlet private var fullNameLabel: UILabel!{
        didSet {
            setupFullNameLabel()
        }
    }
    @IBOutlet private var statusTextField: UITextField!{
        didSet {
            setupStatusTextField()
        }
    }
    @IBOutlet private var setStatusButton: UIButton! {
        didSet {
            setupSetStatusButton()
        }
    }
    
    let avatarImageToLoad: UIImage? = #imageLiteral(resourceName: "foto2")
    
    // MARK: Life cycle
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        setupViews()
        loadingImageToAvatar {result in switch result{
        case .success(let imageToLoad):
            avatarImageView.image = imageToLoad
            print ("Картинка успешно загружена")
        case .failure(let error):
            print (error.localizedDescription)
        }
        }
    }
    
    // MARK: Actions
    
    @IBAction private func setStatusButton(_ sender: Any) {
        print (statusTextField.text ?? "Нет статуса")
    }
    
    // MARK: Setups
    
    private func setupSetStatusButton() {
        setStatusButton.layer.cornerRadius = 4
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOffset.width = 4
        setStatusButton.layer.shadowOffset.height = 4
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFullNameLabel(){
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullNameLabel.textColor = .black
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStatusTextField(){
        statusTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusTextField.textColor = .gray
        statusTextField.backgroundColor = .systemGray4
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupImageView() {

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViews() {
        
         backgroundColor = .systemGray4
         addSubview(avatarImageView)
         addSubview(fullNameLabel)
         addSubview(statusTextField)
         addSubview(setStatusButton)
        
        let constraints = [
            
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            fullNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -34),
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func loadingImageToAvatar (completionHandler: ((Result<UIImage, ApiError>) -> Void)){
        if let newImage = avatarImageToLoad {
            completionHandler(.success(newImage))
        } else {
            completionHandler(.failure(ApiError.notFoundRecourceImage))
        }
    }
}

