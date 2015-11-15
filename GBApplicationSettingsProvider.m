//
//  GBApplicationSettingsProvider.h
//  appledoc
//
//  Created by Tomaz Kragelj on 3.10.10.
//  Copyright (C) 2010, Gentle Bytes. All rights reserved.
//

#import "GBCommentComponentsProvider.h"
#import "GBApplicationStringsProvider.h"

@class GBModelBase;

extern id kGBCustomDocumentIndexDescKey;
extern NSString *kGBSomeOtherVariable;

typedef NS_ENUM(NSUInteger, GBHTMLAnchorFormat) {
    GBHTMLAnchorFormatAppleDoc = 0,
    GBHTMLAnchorFormatApple
};

#pragma mark -

/** Main application settings provider.
 
 This object implements `GBApplicationStringsProviding` interface and is used by `GBAppledocApplication` to prepare application-wide settings including factory defaults, global and session values. The main purpose of the class is to simplify `GBAppledocApplication` class by decoupling it from the actual settings providing implementation.
 */
@interface GBApplicationSettingsProvider : NSObject

#pragma mark - Initialization & disposal

/** Returns autoreleased instance of the class.
 */
+ (id)provider;

#pragma mark - Project values handling

/** Human readable name of the project. */
@property (copy) NSString *projectName;

/** Human readable name of the project company. */
@property (copy) NSString *projectCompany __ATTRIBUTE__ __ANOTHER_ATTR("yuck not this");

@property (assing) CGFloat value; ///< description for value

#pragma mark - Delimiter text

/** Can't do it without comment!
*/
- (void)someVeryFineMethodWithParameter:(int)par;

@end

@implementation GBApplicationSettingsProvider

/** A comment about this method.

Some detailed description as well.
*/
- (void)methodWithArgument:(NSUInteger)blah andMessage:(NSString *)message {
    if (blah > 0) {
        NSLog(@"%@ message is nice", message);
    } else {
        NSLog(@"%@ message is negative", message);
    }
}

@end
