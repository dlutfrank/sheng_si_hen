//
//  VerifyResources.swift
//  T1
//
//  Created by Rong GONG on 28/02/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import Foundation
import UIKit

class VerifyResources {
    
    func verify_video(video: Video) -> Bool {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // reach the file by appending the file folder
        let directory = "remorse_at_death/"+video.directory+"/"+video.sub_directory+"/"
        
        let itemURL: URL? = documentsURL.appendingPathComponent(directory+video.name+".mp4")
        
        if FileManager.default.fileExists(atPath: (itemURL?.path)!) {
            // FILE AVAILABLE
            return true
        } else {
            // "FILE NOT AVAILABLE"
            return false
        }
    }
    
    func verify_video_sub_directory(directory: String, sub_directory: String, names: [String]) -> [Video] {
        
        var missing_videos = [Video]()

        for name_s in names {
            guard let video_test = Video(name: name_s,
                                               directory: directory,
                                               sub_directory:sub_directory) else {
                fatalError("Unable to instantiate video_test")
            }
            if (!verify_video(video: video_test)) {
                missing_videos += [video_test]
            }
        }
        
        return missing_videos
    }
    
}
