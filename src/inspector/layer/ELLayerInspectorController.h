//
//  ELLayerInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"
#import "ELLayer.h"

@interface ELLayerInspectorController : NSWindowController {
  ELLayer *layer;
}

@property ELLayer *layer;

- (void)focus:(ELLayer *)layer;
- (void)selectionChanged:(NSNotification*)notification;

@end