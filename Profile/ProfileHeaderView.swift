
import UIKit
import SnapKit

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
    
    // MARK: Life cycle
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        setupViews()
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
        
        avatarImageView.image = #imageLiteral(resourceName: "foto2")
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
        
        avatarImageView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        addSubview(fullNameLabel)
        
        fullNameLabel.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).offset(27)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        addSubview(setStatusButton)
        
        setStatusButton.snp.makeConstraints (){ button in
            button.top.equalTo(avatarImageView.snp.bottom).offset(16)
            button.leading.equalTo(avatarImageView)
            button.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(16)
        }
        
        addSubview(statusTextField)
        
        statusTextField.snp.makeConstraints { (textField) in
            textField.bottom.equalTo(setStatusButton.snp.top).inset(-34)
            textField.leading.trailing.equalTo(fullNameLabel)
            
        }
    }
}

