//
//  ELSineOscillator.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELSineOscillator : ELRangedOscillator {
  float period;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum period:(float)period;

@property float period;

@end
