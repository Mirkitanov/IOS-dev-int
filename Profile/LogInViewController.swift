/*
 Задание №1 по теме "Run Loop, таймеры"
 "Какие задачи в приложении можно выполнить не сразу,а через некоторое время?"
 
 Я думаю, что не сразу а через некоторое время можно выполнить:
 - Запускать и менять анимацию на экране, например на SplashScreen при запуске приложения и создать визуальный эффект через 1 секунду, продолжительностью 2 секунды;
 - Просмотреть или "залайкать" картинку, только после того, как она будет полностью загружена (например, когда загрузка идет из сети или сервера);
 - Перемотать видео/аудио, когда оно будет загружено;
 - По сути, выполнить какие-то любые действия/обработку с Объектом/Данными только после полной загрузки;
 - Прислать какое-то уведомление/напоминание. Например, мы пользуемся пробной бесплатной версией приложения, которую можно использовать в течение заданного отведенного времени. По истечении этого времени (например 5 часов)  приложение перестанет работать, или нужно оплатить для продолжения работы с ним;
 - В принципе, когда нужно добиться синхронности выполнения задач, чтобы они выполнялись одна за другой;
 - Когда мы ждем получения каких-то данных от предыдущей задачи. Например, как мы ждали, пока отработает взломщик пароля, а затем только отработать вход Польователя;
 - Если мы делаем игру и Игрок стреляет патронами. Когда патроны в обойме закончатся, Игрок сможет стрелять, как только выполнит перезарядку обоймы. Перезарядка может использовать таймер (например, 3 секунды);
 - Можно использовать таймер, если нужно ввести "секретный код" в течение определенного времени (например, одной минуты);
 - Камера может сделать фотоснимок с задержкой по истечении заданного времени (например, 10 секунд).
 */

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet var logInScrollView: UIScrollView!
    
    @IBOutlet var logoImageView: UIImageView!
    
    @IBOutlet var bigFieldForTwoTextFieldsImageView: UIImageView!
    
    @IBOutlet var emailOrPhoneTextField: UITextField!
        
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    
    private let wrapperView = UIView()
    
    let numberForCounter = 20
    var count = 20
    
    var currentTimer = Timer()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        warningLabel.text = "Введите Логин и Пароль"
    }
    
    private func setupTimer() -> Timer{
        let timer = Timer(timeInterval: 1, repeats: true) { timerNew in
                    self.timerLabel.text = "Осталось \(self.count) секунд(ы) до очистки полей"
                    self.count -= 1
        
                    if self.count < 10 {
                        self.timerLabel.textColor = .red
                    } else {
                        self.timerLabel.textColor = .black
                    }
        
                    if self.count == -1 {
                        self.emailOrPhoneTextField.text = ""
                        self.passwordTextField.text = ""
                        self.timerLabel.textColor = .systemBlue
                        self.count = self.numberForCounter
                        self.timerLabel.text = "Поля очищены"
                        timerNew.invalidate()
                    }
                }
        timer.tolerance = 0.3
        return timer
    }
    
    private func startTimer(timer: Timer) -> Void {
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func stopTimer(timer: Timer) {
        self.count = self.numberForCounter
        timer.invalidate()
    }
    
    private func setupViews(){
        navigationController?.navigationBar.isHidden = true
        let longLine: UIView = {
            let line = UIView()
            line.backgroundColor = .lightGray
            line.translatesAutoresizingMaskIntoConstraints = false
            return line
        }()
        
        logInScrollView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        bigFieldForTwoTextFieldsImageView.translatesAutoresizingMaskIntoConstraints = false
        emailOrPhoneTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        logInScrollView.contentInsetAdjustmentBehavior = .automatic
        logInScrollView.backgroundColor = .white
        
        logoImageView.image = #imageLiteral(resourceName: "logo")
        
        bigFieldForTwoTextFieldsImageView.backgroundColor = .systemGray6
        bigFieldForTwoTextFieldsImageView.layer.cornerRadius = 10
        bigFieldForTwoTextFieldsImageView.layer.borderWidth = 0.5
        bigFieldForTwoTextFieldsImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.setTitleColor(.darkGray, for: .selected)
        logInButton.setTitleColor(.darkGray, for: .highlighted)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .disabled)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .selected)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .highlighted)
        logInButton.layer.cornerRadius = 10
        logInButton.layer.masksToBounds = true
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        
        view.addSubview(logInScrollView)
        logInScrollView.addSubview(wrapperView)
        wrapperView.addSubviews(logoImageView,
                                bigFieldForTwoTextFieldsImageView,
                                emailOrPhoneTextField,
                                passwordTextField,
                                logInButton,
                                timerLabel,
                                warningLabel,
                                longLine
        )
        
        let constraints = [
            logInScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logInScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logInScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            logInScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            wrapperView.topAnchor.constraint(equalTo: logInScrollView.topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: logInScrollView.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: logInScrollView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: logInScrollView.bottomAnchor),
            wrapperView.widthAnchor.constraint(equalTo: logInScrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            
            warningLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            warningLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),

            timerLabel.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 10),
            timerLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),

            bigFieldForTwoTextFieldsImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            bigFieldForTwoTextFieldsImageView.heightAnchor.constraint(equalTo: logoImageView.heightAnchor, constant: 0),
            bigFieldForTwoTextFieldsImageView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16),
            bigFieldForTwoTextFieldsImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16),
            
            emailOrPhoneTextField.topAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.topAnchor, constant: 16),
            emailOrPhoneTextField.leadingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.leadingAnchor, constant: 16),
            emailOrPhoneTextField.trailingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.trailingAnchor, constant: -16),
            
            passwordTextField.bottomAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.bottomAnchor, constant: -16),
            passwordTextField.leadingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.trailingAnchor, constant: -16),
            
            longLine.topAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.topAnchor, constant: 49.75),
            longLine.leadingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.leadingAnchor),
            longLine.trailingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.trailingAnchor),
            longLine.bottomAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.bottomAnchor, constant: -49.75)
            ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Keyboard observers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timerLabel.text = ""
        self.currentTimer = setupTimer()
        startTimer(timer: self.currentTimer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer(timer: self.currentTimer)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard actions
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            logInScrollView.contentInset.bottom = keyboardSize.height
            logInScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        logInScrollView.contentInset.bottom = .zero
        logInScrollView.verticalScrollIndicatorInsets = .zero
    }
    
    @objc private func logInButtonPressed() {
        
        let postsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PostsViewController")
        navigationController?.pushViewController(postsViewController, animated: true)
    }
    
}

    extension UIImage {
        func alpha(_ value:CGFloat) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
    }

    extension UIView {
        func addSubviews(_ subviews: UIView...) {
            subviews.forEach { addSubview($0) }
        }
    }
