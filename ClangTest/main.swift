//
//  main.swift
//  ClangTest
//
//  Created by Tomaz Kragelj on 13.11.15.
//  Copyright © 2015 Gentle Bytes. All rights reserved.
//

import Foundation
import libclang

extension String {
	
	init(clangString: CXString) {
		if clangString.data == nil {
			self.init(stringLiteral: "")
		} else {
			let cString = clang_getCString(clangString)
			let string = String(UTF8String: cString)!
			self.init(stringLiteral: string)
		}
	}
	
	init(range: CXSourceRange) {
		let startingLocation = fileInfoFromLocation(clang_getRangeStart(range))
		let endingLocation = fileInfoFromLocation(clang_getRangeEnd(range))
		
		var result = ""
		
		result += "[\(startingLocation.line):\(startingLocation.column)"
		if endingLocation.line == startingLocation.line {
			if endingLocation.column != startingLocation.column {
				result += "-\(endingLocation.column)"
			}
			result += "]"
		} else {
			result += "] - [\(endingLocation.line):\(endingLocation.column)]"
		}
		
		self.init(stringLiteral: result)
	}

}

func fileInfoFromLocation(location: CXSourceLocation) -> (filename: String, line: Int, column: Int) {
	var file: CXFile = nil
	var line: uint32 = 0
	var column: uint32 = 0
	clang_getFileLocation(location, &file, &line, &column, nil)
	
	return (filename: String(clangString: clang_getFileName(file)), line: Int(line), column: Int(column))
}

func tokenKindString(value: CXTokenKind) -> String {
	switch value {
		case CXToken_Punctuation: return "CXToken_Punctuation"
		case CXToken_Keyword: return "CXToken_Keyword"
		case CXToken_Identifier: return "CXToken_Identifier"
		case CXToken_Literal: return "CXToken_Literal"
		case CXToken_Comment: return "CXToken_Comment"
		default: return "unknkown"
	}
}

let file = ("~/Documents/Projects/Testing/Foundation/ClangTest/GBApplicationSettingsProvider.m" as NSString).stringByStandardizingPath

let index = clang_createIndex(0, 0)
let flags = CXTranslationUnit_None.rawValue // CXTranslationUnit_SkipFunctionBodies.rawValue + CXTranslationUnit_Incomplete.rawValue
let translationUnit = clang_parseTranslationUnit(index, file, nil, 0, nil, 0, flags)

clang_visitChildrenWithBlock(clang_getTranslationUnitCursor(translationUnit)) { (cursor, parent) -> CXChildVisitResult in
	let range = clang_getCursorExtent(cursor)
	
	let kindValue = clang_getCursorKind(cursor)
	let kind = String(clangString: clang_getCursorKindSpelling(kindValue))
	let name = String(clangString: clang_getCursorSpelling(cursor))
	
	print("\(kind) {\(kindValue.rawValue)} \(name) \(String(range: range))")
	
	var tokens = UnsafeMutablePointer<CXToken>()
	var count = UInt32(0)
	clang_tokenize(translationUnit, range, &tokens, &count)
	for i: Int in 0..<Int(count) {
		let tokenKindValue = clang_getTokenKind(tokens[i])
		let tokenKind = tokenKindString(tokenKindValue)
		let tokenRange = clang_getTokenExtent(translationUnit, tokens[i])
		let token = String(clangString: clang_getTokenSpelling(translationUnit, tokens[i]))
		print("  {\(tokenKind) \(tokenKindValue.rawValue)} \(token) \(String(range: tokenRange))")
	}
	
	return CXChildVisit_Recurse
}
