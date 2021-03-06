//
//  ELRangedKnob.h
//  Elysium
//
//  Created by Matt Mower on 23/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"

@interface ELRangedKnob : ELKnob {
  float minimum;
  float maximum;
  float stepping;
}

- (id)initWithName:(NSString *)name
           minimum:(float)minimum
           maximum:(float)maximum
          stepping:(float)stepping
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)enabled
         linkValue:(BOOL)linkValue
        oscillator:(ELOscillator *)oscillator;

- (id)initWithName:(NSString *)name minimum:(float)minimum maximum:(float)maximum stepping:(float)stepping;

@property float minimum;
@property float maximum;
@property float stepping;

- (void)setMinimum:(float)minimum maximum:(float)maximum stepping:(float)stepping;

@end
