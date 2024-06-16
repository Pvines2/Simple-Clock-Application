//
//  ViewController.swift
//  Simple Clock Application
//
//  Created by Parker Vines on 6/15/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    
    var timer: Timer?
    var countdownTimer: Timer?
    var countdownDuration: TimeInterval = 0
    var player: AVAudioPlayer?
    var isMusicPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        
            
        
        // Set initial background image
        updateBackgroundImage()
    }
    
    func setupAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                print("Audio session set up successfully")
            } catch {
                print("Failed to set up audio session: \(error.localizedDescription)")
            }
        }
    
    @objc func updateClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        clockLabel.text = formatter.string(from: Date())
        updateBackgroundImage()
    }
    
    func updateBackgroundImage() {
        let hour = Calendar.current.component(.hour, from: Date())
        let backgroundImage: UIImage?
        if hour >= 6 && hour < 18 {
            backgroundImage = UIImage(named: "am_image")
        } else {
            backgroundImage = UIImage(named: "pm_image")
        }
        if let bgImage = backgroundImage {
            self.view.backgroundColor = UIColor(patternImage: bgImage)
        } else {
            print("Background image not found!")
        }
    }

    
  
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        if countdownTimer == nil && !isMusicPlaying {
                    startTimer()
                } else {
                    stopMusic()
                }
    }
    
    func startTimer() {
        countdownDuration = datePicker.countDownDuration
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        startStopButton.setTitle("Stop Music", for: .normal)
    }
    
    @objc func updateTimer() {
        if countdownDuration > 0 {
            countdownDuration -= 1
            timerLabel.text = formatTime(countdownDuration)
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            playMusic()
        }
    }
    
    func formatTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func playMusic() {
            print("Attempting to play music")
            if let url = Bundle.main.url(forResource: "tartini_devilstrill_goulding", withExtension: "mp3") {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.play()
                    isMusicPlaying = true
                    print("Music started playing")
                } catch {
                    print("Error playing music: \(error.localizedDescription)")
                }
            } else {
                print("Alarm audio file not found")
            }
        }
    
    func stopMusic() {
            print("Stopping music")
            player?.stop()
            startStopButton.setTitle("Start Timer", for: .normal)
            timerLabel.text = ""
            countdownDuration = 0
            isMusicPlaying = false
            countdownTimer?.invalidate()
            countdownTimer = nil 
        }
    
    
}

