//
//  ClangParser.m
//  ClangTest
//
//  Created by Tomaz Kragelj on 13.11.15.
//  Copyright © 2015 Gentle Bytes. All rights reserved.
//

#include "Index.h"
#import "ClangParser.h"

@implementation ClangParser

- (void)parseFile:(NSString *)file {
	CXIndex index = clang_createIndex(0, 0);
	CXTranslationUnit translationUnit = clang_parseTranslationUnit(index, file.UTF8String, nil, 0, 0, 0, CXTranslationUnit_SkipFunctionBodies);

	__block BOOL printFile = YES;
	BOOL showTokens = YES;
	
	clang_visitChildrenWithBlock(clang_getTranslationUnitCursor(translationUnit), ^enum CXChildVisitResult(CXCursor cursor, CXCursor parent) {
		CXSourceRange range = clang_getCursorExtent(cursor);
		CXSourceLocation location = clang_getRangeStart(range);

		// Get kind.
		enum CXCursorKind kind = clang_getCursorKind(cursor);

		// Get file and column data.
		CXFile file;
		unsigned line;
		unsigned column;
		clang_getFileLocation(location, &file, &line, &column, NULL);
		CXString filename = clang_getFileName(file);
		CXString name = clang_getCursorSpelling(cursor);
		if (printFile) {
			NSLog(@"%s", clang_getCString(filename));
			printFile = NO;
		}
		NSLog(@"[%u:%u] = (%u) %s", line, column, kind, clang_getCString(name));
		
		// Get tokens.
		if (showTokens) {
			CXToken *tokens;
			unsigned int tokensCount;
			clang_tokenize(translationUnit, range, &tokens, &tokensCount);
			for (unsigned int i=0; i<tokensCount; i++) {
				CXString token = clang_getTokenSpelling(translationUnit, tokens[i]);
				NSLog(@"  %u = %s", i, clang_getCString(token));
			}
		}

		clang_disposeString(name);
		clang_disposeString(filename);
		
		return CXChildVisit_Recurse;
	});
	
	clang_disposeTranslationUnit(translationUnit);
	clang_disposeIndex(index);
}

@end
