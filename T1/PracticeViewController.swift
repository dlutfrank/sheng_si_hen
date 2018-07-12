//
//  PracticeViewController.swift
//  sheng_si_hen
//
//  Created by Rong GONG on 29/06/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import UIKit
import AudioKitUI
import AudioKit


class PracticeViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    var mixer = AKMixer()
    var singingPlayer: AKPlayer?
    var jinghuPlayer: AKPlayer?
    
    @IBOutlet weak var singingVolumeSlider: UIView!
    @IBOutlet weak var jinghuVolumeSlider: UIView!
    
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var ampLabel: UILabel!
    @IBOutlet weak var noteSharpLabel: UILabel!
    @IBOutlet weak var noteFlatLabel: UILabel!
    @IBOutlet weak var audioInputPlot: EZAudioPlot!
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var time_updateUI: Timer!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    func setupPlot() {
        let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.blue
        audioInputPlot.addSubview(plot)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Microphone input
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        silence >>> mixer
        
        if let audioFile = try? AKAudioFile(readFileName: "er_bian_xiang_audio/er_bian_xiang_singing_01.mp3", baseDir: .resources) {
            let player = AKPlayer(audioFile: audioFile)
            player.isLooping = false
            player.buffering = .always //.dynamic
            player >>> mixer
            
            self.singingPlayer = player
        }
        
        if let audioFile = try? AKAudioFile(readFileName: "er_bian_xiang_audio/er_bian_xiang_jinghu_01.mp3", baseDir: .resources) {
            let player = AKPlayer(audioFile: audioFile)
            player.isLooping = false
            player.buffering = .always //.dynamic
            player >>> mixer
            
            self.jinghuPlayer = player
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // assign AudioKit's output to the mixer so it's easy to switch sources
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        setupUI()
        setupPlot()
        self.time_updateUI = Timer.scheduledTimer(timeInterval: 0.1,
                                                  target: self,
                                                  selector: #selector(PracticeViewController.updateUI),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        do {
            try AudioKit.stop()
        } catch {
            AKLog("AudioKit did not start!")
        }
        self.time_updateUI.invalidate()
        self.time_updateUI = nil
        self.jinghuPlayer = nil
        self.singingPlayer = nil
        self.silence = nil
        self.tracker = nil
        self.mic = nil
        self.mixer.disconnectInput()
        self.mixer.disconnectOutput()
        self.mixer.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePlay(_ sender: UIButton) {
        guard let singingPlayer = singingPlayer else { return }
        guard let jinghuPlayer = jinghuPlayer else { return }
        
        if jinghuPlayer.isPlaying {
            AKLog("Stop")
            jinghuPlayer.stop()
            singingPlayer.stop()
            sender.setTitle("▶️", for: .normal)
            
        } else {
            AKLog("Play")
            jinghuPlayer.play()
            singingPlayer.play()
            sender.setTitle("⏹", for: .normal)
        }
    }
    
    func setupUI() {
        let singing_slider_frame = CGRect(x: 0,
                            y: 0,
                            width: self.singingVolumeSlider.frame.size.width,
                            height: self.singingVolumeSlider.frame.size.height)
        
        singingVolumeSlider.addSubview(AKSlider(property: "singing bolume",
                                                           value: (singingPlayer?.volume)!,
                                                           range: 0.0 ... 1.0,
                                                           taper: 1,
                                                           format: "%0.3f",
                                                           color: .blue,
                                                           frame: singing_slider_frame,
                                                           callback: { [weak self] volume in
                                                            self?.singingPlayer?.volume = volume
        }))
        
        let jinghu_slider_frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.jinghuVolumeSlider.frame.size.width,
                                         height: self.jinghuVolumeSlider.frame.size.height)
                
        jinghuVolumeSlider.addSubview(AKSlider(property: "jinghu volume",
                                                value: (jinghuPlayer?.volume)!,
                                                range: 0 ... 1,
                                                taper: 1.0,
                                                format: "%0.3f",
                                                color: .blue,
                                                frame: jinghu_slider_frame,
                                                callback: { [weak self] volume in
                                                    self?.jinghuPlayer?.volume = volume
        }))
    }
    
    @objc func updateUI() {
        if tracker.amplitude > 0.1 {
            freqLabel.text = String(format: "%0.1f", tracker.frequency)
            
            var frequency = Float(tracker.frequency)
            while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
                frequency /= 2.0
            }
            while frequency < Float(noteFrequencies[0]) {
                frequency *= 2.0
            }
            
            var minDistance: Float = 10_000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if distance < minDistance {
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(Float(tracker.frequency) / frequency))
            noteSharpLabel.text = "\(noteNamesWithSharps[index])\(octave)"
            noteFlatLabel.text = "\(noteNamesWithFlats[index])\(octave)"
        }
        ampLabel.text = String(format: "%0.2f", tracker.amplitude)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
