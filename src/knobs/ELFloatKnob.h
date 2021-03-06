//
//  ELFloatKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedKnob.h"
#import "Elysium.h"

@interface ELFloatKnob : ELRangedKnob <NSMutableCopying> {
  float value;
}

- (id)initWithName:(NSString *)name
        floatValue:(float)value
           minimum:(float)minimum
           maximum:(float)maximum
          stepping:(float)stepping
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)_enabled
         linkValue:(BOOL)_linkValue
        oscillator:(ELOscillator *)oscillator;

- (id)initWithName:(NSString *)name floatValue:(float)value minimum:(float)minimum maximum:(float)maximum stepping:(float)stepping;
- (id)initWithName:(NSString *)name linkedToFloatKnob:(ELFloatKnob *)knob;

- (float)value;
- (void)setValue:(float)value;

- (float)dynamicValue;
- (float)dynamicValue:(float)value;

@end
