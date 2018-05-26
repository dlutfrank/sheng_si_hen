//
//  video.swift
//  T1
//
//  Created by Rong GONG on 28/02/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import UIKit


class Video {
    
    //MARK: Properties
    
    var name: String
    var directory: String
    var sub_directory: String
    
    //MARK: Initialization
    
    init?(name: String, directory: String, sub_directory: String)
    {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        guard !directory.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.directory = directory
        self.sub_directory = sub_directory
    }
}

