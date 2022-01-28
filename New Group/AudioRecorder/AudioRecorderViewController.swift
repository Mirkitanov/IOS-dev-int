//
//  AudioRecorderViewController.swift
//  Navigation
//
//  Created by Админ on 12.01.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderViewController: UIViewController {
    
    // MARK: - Properties
    
    private static let defaultButtonTitle = "Начать запись аудио"
    
    private lazy var recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "record.circle.fill"), for: .normal)
        button.setTitle(AudioRecorderViewController.defaultButtonTitle, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
// MARK: - Вопрос для проверяющего
// Не получилось выровнять картинку и надпись на кнопке просто по левому краю кнопки, чтобы они не прыгали. Хотел, чтобы слева была картинка на одном месте, а за ней текст уже разной длины. Пробывал по разному играть UIEdgeInsets, но что-то не вышло как хотел. Как это правильно сделать?
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(button.titleLabel?.bounds.size.width ?? 0), bottom: 0, right: 0)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: (button.image(for: .normal)?.size.width ?? 0), bottom: 0, right: 0)
        
// MARK: - Вопрос для проверяющего
// Вот здесь вообще непонятная ситуация. Здесь мы вроде бы просто регулируем отступы на кнопке. Но интересно получается, если вот эти button.contentEdgeInsets закоментировать и не трогать, то во время записи диктофона нельзя прослушать раннее записанную аудио-запись (я думаю это правильный сценарий) и выдаётся соответствующее алерт-сообщение. Но если коментарии убрать и прописать button.contentEdgeInsets, то ошибки не возникает и Плеер вполне себе позволяеть проиграть аудио-запись во время записи. Почему так возникает и как правильно организовать проигрование/запись?
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(recordButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage (named: "play.fill"), for: .normal)
        button.setTitle("Прослушать аудио-запись", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.isHidden = true
        button.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(playButton)
        return stackView
    }()
    
    private lazy var goToSettingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти в настройки", for: .normal)
        return button
    }()
    
    private lazy var noPermissionStackView: UIStackView = {
        let headerLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "Отсутствует разрешение на запись аудио"
            label.textAlignment = .center
            label.textColor = .label
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            return label
        }()
        
        let secondarylabel: UILabel = {
           let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "Перейдите в настройки, чтобы предоставить необходимые разрешения"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 14, weight: .regular)
            return label
        }()
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(secondarylabel)
        stackView.addArrangedSubview(goToSettingsButton)
        return stackView
    }()
    
    private var audioRecordingSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder? = nil
    private var audioPlayer: AVAudioPlayer? = nil
    private var audioFileURL: URL = {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirertoryURL = documentPath[0]
        let url = documentDirertoryURL.appendingPathComponent("recording.m4a")
        
        return  url
    }()
    
    // MARK: - Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordPermissionRequest()
    }
    
    // MARK: - AudioRecorder Methods
    
    func recordPermissionRequest() {
        do {
            try
                audioRecordingSession.setCategory(.playAndRecord, mode: .default)
            try audioRecordingSession.setActive(true)
            audioRecordingSession.requestRecordPermission(){ [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self?.showRecordingUI()
                    } else {
                        self?.showNoPermissionsUI()
                    }
                }
            }
        } catch {
            print(error)
            self.showNoPermissionsUI()
        }
    }
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 1200,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
           audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            recordButton.setTitle("Остановить аудио-запись", for: .normal)
            
        } catch {
            print(error)
            finishRecording (success: false)
        }
    }
    
    private func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Перезаписать", for: .normal)
            playButton.isHidden = false
        } else {
            let alert = alertCaller(message: "Не удалось записать аудио!")
            self.present(alert, animated: true){
                [unowned self] in
                recordButton.setTitle("Начать запись аудио", for: .normal)
                playButton.isHidden = true
            }
        }
    }
    
    // MARK: - AudioPlayer Methods
    
    private func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            playButton.setImage(UIImage(named: "stop.fill"), for: .normal)
            playButton.setTitle("Остановить", for: .normal)
            
        } catch {
            let alert = alertCaller(message: "Невозможно проиграть аудио-файл")
            self.present(alert, animated: true){
                [unowned self] in
                stopPlayback()
            }
        }
    }
    
    private func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        playButton.setImage(UIImage(named: "play.fill"), for: .normal)
        playButton.setTitle("Прослушать аудио-запись", for: .normal)
    }

    //MARK: - Action-Methods for Buttons
    
    @objc private func recordButtonTapped(_ sender: UIButton) {
        
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        
        if audioPlayer == nil {
            playRecording()
        } else {
            stopPlayback()
        }
    }
    
    @objc private func goToSettingsButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = alertCaller(message: "Невозможно перейти в настройки!")
            self.present(alert, animated: true){
                [weak self] in
                self?.goToSettingsButton.isHidden = true
            }
        }
    }
    
    //MARK:- UI
    
    private func alertCaller (message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        return alert
    }
    
    private func showNoPermissionsUI() {
        view.addSubview(noPermissionStackView)
        let constraints = [
            noPermissionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noPermissionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noPermissionStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showRecordingUI() {
        view.addSubview(buttonsContainerStackView)
        let constraints = [
            buttonsContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsContainerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK:- AVAudioRecorderDelegate

extension AudioRecorderViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: flag)
        }
    }
}

// MARK:- AVAudioPlayerDelegate

extension AudioRecorderViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayback()
    }
}
// MARK: - Вопрос для проверяющего
// Здесь вроде как методы Делега аudioRecorderDidFinishRecording и audioPlayerDidFinishPlaying отрабатывают номально (проверьте точно это пожалуйста). При этом в коде эти методы не нужно вызывать специально. Почему в AudioPlayerViewController метод Делегата udioPlayerDidFinishPlaying при окончании песни не отрабатывал самостоятельно и его нужно было непосредственно вызывать?
