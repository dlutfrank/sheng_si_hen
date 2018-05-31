//
//  DownloadVideo.swift
//  sheng_si_hen
//
//  Created by Rong GONG on 26/05/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import os.log

class DownloadVideo {
    
    var downloadedFilePath = URL(string: "")
    var request: Alamofire.Request?
    var url = [String]()
    var filename = [String]()
    
    func beginDownload(url: String, directory: String, sub_directory: String, filename: String, downloadProgressView: UIProgressView) {
        UIApplication.shared.isIdleTimerDisabled = true
        
//        self.downloadProgressView?.setProgress(value: 0, animationDuration: 0)
        
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let relative_directory = "remorse_at_death/"+directory+"/"+sub_directory+"/"+filename
            self.downloadedFilePath = documentsURL.appendingPathComponent(relative_directory)
//                    if let downloadedFilePath = self.downloadedFilePath {
//                        if downloadedFilePath.exists { try self.downloadedFilePath?.deleteFile() }
            return (self.downloadedFilePath!, [.removePreviousFile, .createIntermediateDirectories])
//                    }
//                } catch let e {
//                    log.warning("Failed to get temporary directory - \(e)")
//                }
            }
        
        self.request = Alamofire.download(url, to:destination).downloadProgress {progress in
            DispatchQueue.main.async {
                downloadProgressView.setProgress(Float(progress.fractionCompleted * 100), animated: true)
//                print("Progress: \(progress.fractionCompleted)")
            }
            }.response { defaultDownloadResponse in
                // TODO: Handle cancelled error
                if let error = defaultDownloadResponse.error {
                    print("Download Failed with error - \(error)")
//                    self.onError(.Download)
                    return
                }
                guard let downloadedFilePath = self.downloadedFilePath else { return }
                print("Downloaded file successfully to \(downloadedFilePath)")
                downloadProgressView.isHidden = true
                // TODO: Handle downloaded file
        }
    }
    
    func cancelDownload(completionHandler: @escaping (Bool) -> Void) {
        self.url = []
        self.filename = []
        self.request?.cancel()
        completionHandler(true)
    }
    
    func beginDownloadBackground(url: [String], directory: String, sub_directory: String, filename: [String], downloadProgressView: UIProgressView, downloadBtn: UIButton, tasks: Int, completionHandler: @escaping (Bool) -> Void) {
        
        self.url = url
        self.filename = filename
        
        if let url_last = self.url.popLast(), let fn = self.filename.popLast() {
            let destination: DownloadRequest.DownloadFileDestination = {_, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let relative_directory = "remorse_at_death/"+directory+"/"+sub_directory+"/"+fn
                self.downloadedFilePath = documentsURL.appendingPathComponent(relative_directory)
                return (self.downloadedFilePath!, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            self.request = BackendAPIManager.sharedInstance.alamoFireManager.download(url_last, to: destination)
                .downloadProgress{progress in
                DispatchQueue.main.async{downloadProgressView.setProgress(Float(progress.fractionCompleted), animated: true)}
            }.response{defaultDownloadResponse in
                    self.beginDownloadBackground(url: self.url, directory: directory, sub_directory: sub_directory, filename: self.filename, downloadProgressView: downloadProgressView, downloadBtn: downloadBtn, tasks: tasks, completionHandler: completionHandler)
                // TODO: Handle cancelled error
                if let error = defaultDownloadResponse.error {
                    print("Download Failed with error - \(error)")
                    //                    self.onError(.Download)
                    completionHandler(false)
                    return
                }
                guard let downloadedFilePath = self.downloadedFilePath else { return }
                print("Downloaded file successfully to \(downloadedFilePath)")
                // TODO: Handle downloaded file
                completionHandler(true)
            }
        }
    }
}
