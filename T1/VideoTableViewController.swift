//
//  VideoTableViewController.swift
//  T1
//
//  Created by gong on 21/03/2017.
//  Copyright © 2017 Ramunas Jurgilas. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
//import MPMoviePlayerController-Subtitles

extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}

func blurImage(image:UIImage) -> UIImage? {
    let context = CIContext(options: nil)
    let inputImage = CIImage(image: image)
    let originalOrientation = image.imageOrientation
    let originalScale = image.scale
    
    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    filter?.setValue(20.0, forKey: kCIInputRadiusKey)
    let outputImage = filter?.outputImage
    
    var cgImage:CGImage?
    
    if let asd = outputImage
    {
        cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
    }
    
    if let cgImageA = cgImage
    {
        return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
    }
    
    return nil
}

class VideoTableViewController: UITableViewController {
    
    var row_segue_received: Int?
    
    var directory_name: String?
    
    var player = AVPlayerViewController_touch()
    
    var YCOverlayView: YCController?

    var mainItem: AVPlayer?
    var firstItem: AVPlayer?
    var secondItem: AVPlayer?
    var thirdItem: AVPlayer?
    var fourthItem: AVPlayer?
    var fifthItem: AVPlayer?
    
    var timer: Timer?
    var START_TIME: CMTime?
    var END_TIME: Double?
    
    var timeToJumpBack: Double?
    
    // record the tag of clicked video
    var tag_sender: Int?
    
    let resource_verifier = VerifyResources()
    
    let back_ground_horizontal = blurImage(image: UIImage(named: "back_ground_horizontal.jpg")!)
    let back_ground_vertical = blurImage(image: UIImage(named: "back_ground_vertical.jpg")!)
    
    var aria_names = [String]()
    var jsonResults = Array<Dictionary<String, Array<Any>>>()
    var btn_names = [String]()
    
    var observer_switchVideo: NSObjectProtocol!
    var observer_wakeOverlapView: NSObjectProtocol!
    var observer_doneButtonPressed: NSObjectProtocol!
    
    private func loadJson(json_resource: String) -> Array<Dictionary<String, Array<Any>>> {
        let ret = Array<Dictionary<String, Array<Any>>>()
        if let path = Bundle.main.path(forResource: json_resource, ofType: "json", inDirectory: "jsons") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonResult as! Array<Dictionary<String, Array<Any>>>
            } catch {
                print("Parse json: \(error)")
            }
        }
        return ret
    }
    
    private func parseJsonAriaName(jsonResults: Array<Dictionary<String, Array<Any>>>) -> Array<String> {
        var aria_names = [String]()
        for dict_aria in jsonResults {
            aria_names += [Array(dict_aria.values)[0][0] as! String]
        }
        return aria_names
    }
    
    private func loadHorizontalBG() {
        tableView.backgroundView = UIImageView(image: back_ground_horizontal)
        tableView.backgroundView?.backgroundColor = UIColor .white
        tableView.backgroundView?.contentMode = .scaleToFill
    }
    
    private func loadVerticalBG() {
        tableView.backgroundView = UIImageView(image: back_ground_vertical)
        tableView.backgroundView?.backgroundColor = UIColor .white
        tableView.backgroundView?.contentMode = .scaleToFill
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if  (UIApplication.shared.statusBarOrientation.isLandscape) {
            loadHorizontalBG()
        } else {
            loadVerticalBG()
        }
        
        self.timeToJumpBack = 0.0
        
        if row_segue_received == 0 {
            directory_name = "head_face"
        } else if row_segue_received == 1 {
            directory_name = "makeup"
        } else if row_segue_received == 2 {
            directory_name = "costume"
        } else if row_segue_received == 3 {
            directory_name = "figure"
        } else if row_segue_received == 4 {
            directory_name = "teaching"
        } else if row_segue_received == 5 {
            directory_name = "performing"
        } else {
            print("invalid row segue number.")
        }

        // load video info json file
        jsonResults = loadJson(json_resource: directory_name!)
        
        // get aria names from json
        aria_names = parseJsonAriaName(jsonResults: jsonResults)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        
        player.view.frame = self.view.frame
        player.view.sizeToFit()
        player.showsPlaybackControls = true

    }
    
    func doneButtonPressed(notification: Notification) -> Void {
        // when click done button, remove overlay views
        removeYCOverlayView()
        self.timer?.invalidate()
        
        NotificationCenter.default.removeObserver(observer_switchVideo)
        NotificationCenter.default.removeObserver(observer_wakeOverlapView)
        NotificationCenter.default.removeObserver(observer_doneButtonPressed)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
                if UIDevice.current.orientation.isLandscape {
                    loadHorizontalBG()
                } else {
                    loadVerticalBG()
                }
        
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            if self.player.player?.timeControlStatus == .paused || self.player.player?.timeControlStatus == .playing {
                self.readdYCOverlayView()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aria_names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ChangduanTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChangduanTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ChangduanTableViewCell.")
        }
        
        cell.changduanNameLabel.text = aria_names[indexPath.row]
        
        cell.downloadBtn.tag = indexPath.row
        cell.downloadBtn.isUserInteractionEnabled = false
        cell.downloadBtn.setTitleColor(.gray, for: .normal)
        
        let aria_folder_name = Array(jsonResults[indexPath.row].keys)
        let video_array = Array(jsonResults[indexPath.row].values)[0][1] as! Array<Array<String>>
        var video_names = [String]()
        for v in video_array {
            video_names += [v[0]]
        }
        
        // check if there is missing videos
        let missing_videos = resource_verifier.verify_video_sub_directory(directory: directory_name!, sub_directory: aria_folder_name[0], names: video_names)
        
        if !missing_videos.isEmpty {
            cell.downloadBtn.isUserInteractionEnabled = true
            cell.downloadBtn.setTitleColor(self.view.tintColor, for: .normal)
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if cell?.reuseIdentifier == "ChangduanTableViewCell" {
            let aria_folder_name = Array(jsonResults[indexPath.row].keys)
            let video_array = Array(jsonResults[indexPath.row].values)[0][1] as! Array<Array<String>>
            var video_names = [String]()
            btn_names = [String]()
            for v in video_array {
                video_names += [v[0]]
                btn_names += [v[1]]
            }
            playVideos(aria_folder_name: aria_folder_name[0],
                       video_names: video_names,
                       btn_names: btn_names,
                       row_segue: row_segue_received!)
        }
    }
    
    func playVideos(aria_folder_name: String, video_names: Array<String>, btn_names: Array<String>, row_segue: Int) {
        self.showDetailViewController(player, sender: self)
        
        observer_switchVideo = NotificationCenter.default.addObserver(forName: Notification.Name("switchVideo"),
                                                                      object:nil,
                                                                      queue:nil,
                                                                      using: switchVideoAndPlay)
        
        observer_wakeOverlapView = NotificationCenter.default.addObserver(forName: Notification.Name("wakeOverlayView"),
                                                                          object:nil,
                                                                          queue:nil,
                                                                          using: wakeOverlayView)
        
        observer_doneButtonPressed =  NotificationCenter.default.addObserver(forName: NSNotification.Name.kAVPlayerViewControllerDismissingNotification, object: nil, queue: nil, using: doneButtonPressed)
        
        setupPlayer(menu_folder_name: directory_name!, aria_folder_name: aria_folder_name, video_names: video_names)

        if row_segue == 0 { // head face
            playVideos(tag_player: 0)
        } else if row_segue == 1 { // makeup
            playVideos(tag_player: 1)
        } else if row_segue == 2 { // costume
            playVideos(tag_player: 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.addYCOverlayView(btn_names: btn_names, tag_view: 97)
            })
        } else if row_segue == 3 { // figure
            playVideos(tag_player: 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.addYCOverlayView(btn_names: btn_names, tag_view: 98)
            })
        } else if row_segue == 4 { // teaching
            playVideos(tag_player: 4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.addYCOverlayView(btn_names: btn_names, tag_view: 99)
            })
        } else if row_segue == 5 { // performing
            playVideos(tag_player: 5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.addYCOverlayView(btn_names: btn_names, tag_view: 100)
            })
        } else {
            print("Not a valdi teaching performing index.")
        }
    }
    
//    func jump2JXAndPlay(notification: Notification) -> Void {
//        self.timeToJumpBack = player.player?.currentTime().seconds
////        removeMainOverlayView()
//        removeYCOverlayView()
//
//        player.player?.replaceCurrentItem(with: nil)
//        //player.view.removeFromSuperview()
//        setupJiaoxuePlayer(tag_sender: self.tag_sender!)
//        playJiaoxuePlayer(startTime: changduans[self.tag_sender!].jiaoxue_st!, endTime: changduans[self.tag_sender!].jiaoxue_et!)
//    }

//    func jump2YCAndPlay(notification: Notification) -> Void {
//
//        removeJXOverlayView()
//
//        player.player?.replaceCurrentItem(with: nil)
//        //player.view.removeFromSuperview()
//        //            print(timeToJumpBack!)
//        //            print(changduans[changduans.count-1].yanchu_et!)
//
//        setupYanchuPlayer(tag_sender: self.tag_sender!)
//        playYanchuPlayer(startTime: self.timeToJumpBack!, endTime: changduans[changduans.count-1].yanchu_et!)
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupPlayer(menu_folder_name: String, aria_folder_name: String, video_names: Array<String>) {
        
        // reach the file by appending the file folder
        let directory = "remorse_at_death/"+menu_folder_name+"/"+aria_folder_name
        
        let mainItemURL: String? = Bundle.main.path(forResource: video_names[0], ofType: ".mp4", inDirectory: directory)
        self.mainItem = AVPlayer(url: NSURL.fileURL(withPath: mainItemURL!) as URL )

        if video_names.count > 1{
            let firstItemURL: String? = Bundle.main.path(forResource: video_names[1], ofType: ".mp4", inDirectory: directory)
            self.firstItem = AVPlayer(url: NSURL.fileURL(withPath: firstItemURL!) as URL )
        }

        if video_names.count > 2 {
            let secondItemURL: String? = Bundle.main.path(forResource: video_names[2], ofType: ".mp4", inDirectory: directory)
            self.secondItem = AVPlayer(url: NSURL.fileURL(withPath: secondItemURL!) as URL )
        }

        if video_names.count > 3 {
            let thirdItemURL: String? = Bundle.main.path(forResource: video_names[3], ofType: ".mp4", inDirectory: directory)
            self.thirdItem = AVPlayer(url: NSURL.fileURL(withPath: thirdItemURL!) as URL )
        }

        if video_names.count > 4 {
            let fourthItemURL: String? = Bundle.main.path(forResource: video_names[4], ofType: ".mp4", inDirectory: directory)
            self.fourthItem = AVPlayer(url: NSURL.fileURL(withPath: fourthItemURL!) as URL )
        }

        if video_names.count > 5 {
            let fifthItemURL: String? = Bundle.main.path(forResource: video_names[5], ofType: ".mp4", inDirectory: directory)
            self.fifthItem = AVPlayer(url: NSURL.fileURL(withPath: fifthItemURL!) as URL )
        }
    }
    
    func playVideos(tag_player: Int) {
        
    
        player.view.tag = tag_player

        player.player = mainItem

    
        // start play from START_TIME, end at END_TIME
//        self.START_TIME = CMTimeMake(Int64(startTime*10.0), 10)
//        self.END_TIME   = endTime
//
//        player.player?.seek(to: START_TIME!, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
//        // Subtitle file
//        let subtitleFile = Bundle.main.path(forResource: "main_1_subtitles", ofType: "srt")
//        let subtitleURL = URL(fileURLWithPath: subtitleFile!)
//
//        //        NotificationCenter.default.addObserver(self, selector: #selector(stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//
//        // Add subtitles
//        player.addSubtitles().open(file: subtitleURL, encoding: String.Encoding.utf8)
//
//        player.subtitleLabel?.isHidden = false
//
//        // Change text properties
//        player.subtitleLabel?.textColor = UIColor.red
        
        player.player?.play()

    }
    
    @objc func checkEndingTime() {
        if (player.player?.currentTime().seconds)! >= self.END_TIME! {
            player.player?.pause()
            self.timer?.invalidate()
        }
    }
    
    func wakeOverlayView(notification: Notification) -> Void {
       readdYCOverlayView()
    }
    
    func readdYCOverlayView() {
        if player.view.tag > 1 {
            removeYCOverlayView()
        }
        if player.view.tag == 2 {
            addYCOverlayView(btn_names: self.btn_names, tag_view: 97)
        } else if player.view.tag == 3 {
            addYCOverlayView(btn_names: self.btn_names, tag_view: 98)
        } else if player.view.tag == 4 {
            addYCOverlayView(btn_names: self.btn_names, tag_view: 99)
        } else if player.view.tag == 5 {
            addYCOverlayView(btn_names: self.btn_names, tag_view: 100)
        }
    }
    
    func addYCOverlayView(btn_names: Array<String>, tag_view: Int) {
        YCOverlayView = Bundle.main.loadNibNamed("YCController", owner: self, options: nil)?[0] as? YCController
        if let contentOverlayView = YCOverlayView {
            contentOverlayView.resetBtnImages(btn_names: self.btn_names)
            contentOverlayView.layer.cornerRadius = 8
            //grabs the height of your view
            let theHeight = player.view.frame.size.height
            let theWidth = player.view.frame.size.width
            
            var overlay_height = CGFloat(0.0)
            if contentOverlayView.frame.height < theHeight*2.0/3.0 {
                overlay_height = contentOverlayView.frame.height
            } else {
                overlay_height = theHeight*2.0/3.0
            }
            let overlay_width = contentOverlayView.frame.width
            // set up overlayView frame
            contentOverlayView.frame = CGRect(x: theWidth - overlay_width,
                                              y: theHeight/2.0 - overlay_height/2.0 ,
                                              width: overlay_width,
                                              height: overlay_height)
            contentOverlayView.tag = tag_view
            contentOverlayView.isHidden = false
            switchOverlayButtonImage(ycOverlayView: contentOverlayView)
            contentOverlayView.alpha = 0.7
            Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) { (timer) in
                contentOverlayView.removeFromSuperview()
            }
            player.view.addSubview(contentOverlayView)
        }
    }

    func removeYCOverlayView() {
        for i in 97...100 {
            if let viewWithTag = player.view.viewWithTag(i) {
                viewWithTag.removeFromSuperview()
            }
        }
        
    }
    
    func switchOverlayButtonImage(ycOverlayView: YCController) -> Void {
        switch player.player {
        case self.mainItem:
            ycOverlayView.setBtn0Image(image_name: self.btn_names[0])
        case self.firstItem:
            ycOverlayView.setBtn1Image(image_name: self.btn_names[1])
        case self.secondItem:
            ycOverlayView.setBtn2Image(image_name: self.btn_names[2])
        case self.thirdItem:
            ycOverlayView.setBtn3Image(image_name: self.btn_names[3])
        case self.fourthItem:
            ycOverlayView.setBtn4Image(image_name: self.btn_names[4])
        case self.fifthItem:
            ycOverlayView.setBtn5Image(image_name: self.btn_names[5])
        default:
            ycOverlayView.setBtn0Image(image_name: self.btn_names[0])
        }
    }
    
    
    func switchVideoAndPlay(notification: Notification) -> Void {
        
        // save current playing time and pause video
        let timeToResume = player.player?.currentTime()
//        print("\(timeToResume?.seconds)")
        player.player?.pause()
        
        // unpack notification userInfo, get play item
        guard let userInfo = notification.userInfo,
            let idxVideo = userInfo["idx"] as? Int else {
                print("No userInfo found.")
                return
        }

        // switch videos
        switch idxVideo {
        case 0:
            player.player = self.mainItem
        case 1:
            player.player = self.firstItem
        case 2:
            player.player = self.secondItem
        case 3:
            player.player = self.thirdItem
        case 4:
            player.player = self.fourthItem
        case 5:
            player.player = self.fifthItem
        default:
            print("\(idxVideo) not exist.")
            return
        }
                
        // seek to saved play time and play
        player.player?.seek(to: timeToResume!, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
//        // Subtitle file
//        let subtitleFile = Bundle.main.path(forResource: "main_1_subtitles", ofType: "srt")
//        let subtitleURL = URL(fileURLWithPath: subtitleFile!)
//
//        // Add subtitles
//        player.open(file: subtitleURL, encoding: String.Encoding.utf8)
//
//        // Change text properties
//        player.subtitleLabel?.textColor = UIColor.red
        
        player.player?.play()
        
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VideoTableViewController.checkEndingTime), userInfo: nil, repeats: true)
//        
    }
    
    func stopedPlaying() {
        YCOverlayView?.isHidden = false
    }
}
