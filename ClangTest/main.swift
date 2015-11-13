//
//  main.swift
//  ClangTest
//
//  Created by Tomaz Kragelj on 13.11.15.
//  Copyright © 2015 Gentle Bytes. All rights reserved.
//

import Foundation

let parser = ClangParser()

let file = ("~/Documents/Projects/Testing/Foundation/ClangTest/GBApplicationSettingsProvider.m" as NSString).stringByStandardizingPath

parser.parseFile(file)

