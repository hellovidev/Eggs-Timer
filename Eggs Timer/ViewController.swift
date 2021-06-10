//
//  ViewController.swift
//  Eggs Timer
//
//  Created by Sergey Romanchuk on 9.06.21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var player: AVAudioPlayer?
    
    private var totalTime: Int = 60
    private var secondsPassed: Int = 60
    
    private var timer: Timer = Timer()
    private let eggTimes: [String: Int] = ["Soft": 5, "Medium": 7, "Hard": 12]

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        titleView.text = "How do you like your eggs? "
        timer.invalidate()
        totalTime = 60
        secondsPassed = 60
        
        let hardness = sender.currentTitle!
        totalTime *= eggTimes[hardness]!
        secondsPassed = totalTime
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed > 0 {
            secondsPassed -= 100
            let timeProgress: Float = Float(secondsPassed) / Float(totalTime)
            progressView.progress = timeProgress
        } else {
            timer.invalidate()
            titleView.text = "Complete!"
            playAlarm()
        }
    }
    
    func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
