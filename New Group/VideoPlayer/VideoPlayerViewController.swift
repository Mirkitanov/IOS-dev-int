//
//  VideoPlayerViewController.swift
//  Navigation
//
//  Created by Админ on 11.01.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
import WebKit
import AVKit

class VideoPlayerViewController: UIViewController {

// MARK: - Private properties
    
    private let videoWebView: WKWebView = {
// MARK: - Вопрос для проверяющего
// Как правильно настроить размер отображаемого видео?
        let webView = WKWebView(frame: CGRect(origin: .zero, size: .zero))
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.clipsToBounds = true
        webView.contentMode = .scaleToFill
        return webView
    }()
    
    let videoPlayerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        return tableView
    }()
    
    private var currentIndex = 0 {
        didSet {
            videoPlayerTableView.reloadRows(at: [IndexPath(row: oldValue, section: 0), IndexPath(row: currentIndex, section: 0)], with: .none)
        }
    }
    
// MARK: - Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPlayerTableView.delegate = self
        videoPlayerTableView.dataSource = self
        
        view.addSubviews(videoPlayerTableView)
        
        let consraints = [
            videoPlayerTableView.topAnchor.constraint(equalTo: view.topAnchor),
            videoPlayerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(consraints)
        playVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        //ставим на паузу аудиоплеер, чтобы не мешал видеоплееру
        AudioPlayerTrigger.shouldAudioPlayerToPlaying = false
    }

// MARK: - Private methods
    
    private func playVideo(index: Int = 0) {
        guard VideoPlaylistStorage.videos.indices.contains(index) else {
            print("Invalid index")
            return
        }
        
        let urlString = VideoPlaylistStorage.videos[index].url
        
        guard let url = urlString else {
            print("Invalid URL")
            return
        }
// MARK: - Вопрос для проверяющего
/*
         Вот этот момент из лекции почему-то не запускается нормально. В модальном окне идет Загрузка контента по заданному URL, но так и не загружается. Почему?
         
        // Создаём AVPlayer со ссылкой на видео.
        let player = AVPlayer(url: url)

        // Создаём AVPlayerViewController и передаём ссылку на плеер.
        let controller = AVPlayerViewController()
        controller.player = player

        // Показываем контроллер модально и запускаем плеер.
        present(controller, animated: true) {
            player.play()
        }
 */
        
        currentIndex = index
        
// MARK: - Вопрос для проверяющего
// Здесь проиcходит загрузка контента по URL. После того когда нажимаем на кнопку Play непосредственно в YouTube, видео начинает автоматически проигрываться в плеере. Хотя я плеер ещё не запускал.
// - Как контролировать момент перехода в плеер?
// - Как организовать проигрывание видео в маленьком окошке videoWebView без перехода в плеер и без перехода на отдельный экран?
// - Также непонятно, почему некоторые видео расширяются по высоте через несколько секунд после загрузки (такие как "Утомленные Солнцем" из моего списка), а некоторые нет. С чем это связано? И как на это влиять?
//- Также контент YouTube иногда прокручивается вместе с основным видео, а в основном основное видео стается неподвижным, а прокручивается дополнительный контент под видео. С чем это связано? И как на это влиять?
        videoWebView.load(URLRequest(url: url))
    }
}

// MARK: - Extensions

extension VideoPlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(index: indexPath.row)
        print("selected")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return .zero }
        
// MARK: - Вопрос для проверяющего
// Как здесь правильно организовать нужную высоту для Хедера? На что ориентироваться? Пытался выставить высоту контента, не получилось. Хотелось бы настроить именно под размер(высоту) загружаемого видео
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return videoWebView
    }
}

extension VideoPlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoPlaylistStorage.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = VideoPlaylistStorage.videos[indexPath.row].title
        cell.accessoryType = currentIndex == indexPath.row ? .checkmark : .none
        cell.backgroundColor = .tertiarySystemGroupedBackground
        return cell
    }
}
