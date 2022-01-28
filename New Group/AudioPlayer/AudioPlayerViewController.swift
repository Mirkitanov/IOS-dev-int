//
//  AudioPlayerViewController.swift
//  Navigation
//
//  Created by Админ on 07.01.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    
    //MARK: - Properties
    
    private var currentTimer = Timer()
    
    private var counterForTimer = 0
    
    private let trackCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackDurationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var progressViewIndicator: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: true)
        progress.tintColor = .systemBlue
        progress.trackTintColor = .systemGray4
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private var audioPlayer = AVAudioPlayer()
    
    private var tracksCount = 0
    
    private var songs = ["Dima Bilan - Molniya",
                         "Artur Pirozhkov - Zacepila",
                         "Survivor - Eye of the Tiger",
                         "Queen - Show Must Go On",
                         "Habib - Yagoda-malinka",
                         "ohah",
                         "aheeah",
                         "harmonyvocal"
    ]
    
    private let type = "mp3"
    
    private lazy var playButton = AVControlButton(imageName: "play.fill", controller: self, selector: #selector(startPlaying))
    
    private lazy var stopButton = AVControlButton(imageName: "stop.fill", controller: self, selector: #selector(stopPlaying))
    
    private lazy var pauseButton = AVControlButton(imageName: "pause.fill", controller: self, selector: #selector(pausePlaying))
    
    private lazy var nextButton = AVControlButton(imageName: "forward.end.fill", controller: self, selector: #selector(nextTrack))
    
    private lazy var previousButton = AVControlButton(imageName: "backward.end.fill", controller: self, selector: #selector(prevTrack))
    
    private lazy var avControlsButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 45.0
        stackView.addArrangedSubview(previousButton)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(pauseButton)
        stackView.addArrangedSubview(stopButton)
        stackView.addArrangedSubview(nextButton)
        return stackView
    }()
    
    private let trackTitleLabel: UILabel = {
        let trackLabel = UILabel()
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.font = .systemFont(ofSize: 19.0, weight: .bold)
        trackLabel.textAlignment = .center
        trackLabel.textColor = .systemBlue
        return trackLabel
    }()
    
    //MARK: - Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
// MARK: - Вопрос для проверяющего
/* Не совсем понимаю необходимость этого участка кода из лекции. Без него всё работает нормально. Нужно его прописывать или нет? Объясните пожалуйста
         
        // конфигурирование аудиосессии - вывода звука на системное устройство (наушники или динамик)
        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try! AVAudioSession.sharedInstance().setActive(true)
*/
        preparePlayer(track: songs[tracksCount])
        setupUI()
        
// MARK: - Вопрос для проверяющего
// Назначаю Делегата для audioPlayer. Но как-то в целом это ни на что не влияет. Может я не правильно назначил? И нужно ли это делать?
        audioPlayer.delegate = self
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        previousButton.tintColor = .lightGray
        previousButton.isUserInteractionEnabled = false
        pauseButton.isHidden = true
        
        view.backgroundColor = .systemBackground
        view.addSubviews(avControlsButtonsStackView,
                         trackTitleLabel,
                         trackCurrentTimeLabel,
                         trackDurationLabel,
                         progressViewIndicator)
        
        let constraints = [
            avControlsButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avControlsButtonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            playButton.widthAnchor.constraint(equalToConstant: 18.0),
            pauseButton.widthAnchor.constraint(equalToConstant: 18.0),
            stopButton.widthAnchor.constraint(equalToConstant: 18.0),
            
            trackDurationLabel.bottomAnchor.constraint(equalTo: avControlsButtonsStackView.topAnchor, constant: -22.0),
            trackDurationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            trackDurationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            progressViewIndicator.bottomAnchor.constraint(equalTo: avControlsButtonsStackView.topAnchor, constant: -50.0),
            progressViewIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            progressViewIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            trackCurrentTimeLabel.bottomAnchor.constraint(equalTo: progressViewIndicator.topAnchor, constant: -10.0),
            trackCurrentTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            trackCurrentTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            trackTitleLabel.bottomAnchor.constraint(equalTo: progressViewIndicator.topAnchor, constant: -40.0),
            trackTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            trackTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTimer() -> Timer{
        let timer = Timer(timeInterval: 0.001, repeats: true) { [self] timerNew in
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let formattedString = formatter.string(from: TimeInterval(self.counterForTimer))!
            let formattedDurationString = formatter.string(from: TimeInterval(self.audioPlayer.duration))!
            
            self.trackCurrentTimeLabel.text = "\(formattedString)"
            self.trackDurationLabel.text = "Длительность трэка \(formattedDurationString)"
            
            if self.audioPlayer.isPlaying {
                self.counterForTimer = Int(self.audioPlayer.currentTime)
                updateProgressView()
                if !AudioPlayerTrigger.shouldAudioPlayerToPlaying {
                    self.pausePlaying()
                }
            } else {
                if self.audioPlayer.currentTime == 0 {
                    pauseButtonIsHidden()
                    stopButton.tintColor = .lightGray
                    stopButton.isUserInteractionEnabled = false
// MARK: - Вопрос для проверяющего
// Вот здесь прописываю вызов метода Делегата audioPlayerDidFinishPlaying. Не должен ли он вызываться автоматически при окончании трека?
                    audioPlayerDidFinishPlaying(self.audioPlayer, successfully: true)
                }
                timerNew.invalidate()
            }
        }
        timer.tolerance = 0.0003
        return timer
    }
    
    private func startTimer(timer: Timer) -> Void {
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func stopTimer(timer: Timer) {
        self.counterForTimer = 0
        timer.invalidate()
    }
    
    //MARK: - Actions
    
    @objc private func startPlaying() {
        self.currentTimer = setupTimer()
        startTimer(timer: self.currentTimer)
        AudioPlayerTrigger.shouldAudioPlayerToPlaying = true
        audioPlayer.play()
        playButtonIsHidden()
        stopButton.tintColor = .black
        stopButton.isUserInteractionEnabled = true
    }
    
    @objc private func stopPlaying() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        preparePlayer(track: songs[tracksCount])
        stopTimer(timer: self.currentTimer)
    }
    
    @objc private func pausePlaying() {
        audioPlayer.pause()
        print(audioPlayer.currentTime)
        print(NSString(format:"%.2f", audioPlayer.currentTime).self)
        print(audioPlayer.duration)
        pauseButtonIsHidden()
        stopTimer(timer: self.currentTimer)
    }
    
    @objc private func prevTrack() {
        if tracksCount > 0 {
            tracksCount -= 1
            stopPlaying()
            startPlaying()
            trackTitleLabel.text = songs[tracksCount]
        }
    }
    
    @objc private func nextTrack() {
        if tracksCount < songs.count - 1 {
            tracksCount += 1
            stopPlaying()
            startPlaying()
            trackTitleLabel.text = songs[tracksCount]
        }
    }
    
    private func preparePlayer(track: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: track, ofType: type)!))
            pauseButtonIsHidden()
            trackTitleLabel.text = songs[tracksCount]
            self.trackCurrentTimeLabel.text = "00:00:00"
            self.progressViewIndicator.progress = 0
            self.trackDurationLabel.text = "Длительность трэка ********"
            
            stopButton.tintColor = .lightGray
            stopButton.isUserInteractionEnabled = false
            
            if tracksCount == 0 {
                previousButton.tintColor = .lightGray
                previousButton.isUserInteractionEnabled = false
            }
            
            if tracksCount > 0 {
                previousButton.tintColor = .black
                previousButton.isUserInteractionEnabled = true
            }
            
            if tracksCount < songs.count - 1 {
                nextButton.tintColor = .black
                nextButton.isUserInteractionEnabled = true
            }
            
            if tracksCount == songs.count - 1 {
                nextButton.tintColor = .lightGray
                nextButton.isUserInteractionEnabled = false
            }
            
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    private func togglePlayPauseButtons() {
        pauseButton.isHidden.toggle()
        playButton.isHidden.toggle()
    }
    
    private func pauseButtonIsHidden() {
        pauseButton.isHidden = true
        playButton.isHidden = false
    }
    
    private func playButtonIsHidden() {
        pauseButton.isHidden = false
        playButton.isHidden = true
    }
    
    private func updateProgressView(){
// MARK: - Вопрос для проверяющего
// Кажется, что progress заполняется с неким запозданием. А на трэке, который длится 1 секунду с небольшим, progress до конца не доходит. Как с этим бороться?
        if progressViewIndicator.progress <= 1 {
            self.progressViewIndicator.progress = Float(audioPlayer.currentTime)/Float(audioPlayer.duration)
        }
    }
}

//MARK: - AVAudioPlayerDelegate

// MARK: - Вопрос для проверяющего
// Как правильно пользоваться методом audioPlayerDidFinishPlaying для Делегата? Я думал, что данный метод должен вызываться автоматически при окончании трэка, ведь я назначил audioPlayer.delegate = self. Но этого не происходит, и приходится прописывать вызов данного метода в строке 181
extension AudioPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        guard tracksCount < songs.count-1 else {
            return
        }
        self.nextTrack()
    }
}
