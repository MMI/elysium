//
//  BridgeSupportController.h
//  JSCocoa
//
//  Created by Patrick Geiller on 08/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#ifndef JSCocoa_iPhone
#import <Cocoa/Cocoa.h>
#endif

@interface BridgeSupportController : NSObject {


	NSMutableArray*			paths;
	NSMutableArray*			xmlDocuments;

	NSMutableDictionary*	hash;
}

+ (id)sharedController;

- (BOOL)loadBridgeSupport:(NSString*)path;
- (BOOL)isBridgeSupportLoaded:(NSString*)path;
- (NSUInteger)bridgeSupportIndexForString:(NSString*)string;

/*
- (NSString*)query:(NSString*)name withType:(NSString*)type;
- (NSString*)query:(NSString*)name withType:(NSString*)type inBridgeSupportFile:(NSString*)file;
*/
- (NSString*)queryName:(NSString*)name;
- (NSString*)queryName:(NSString*)name type:(NSString*)type;


@end
