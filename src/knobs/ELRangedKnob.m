//
//  ELRangedKnob.m
//  Elysium
//
//  Created by Matt Mower on 23/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELRangedKnob.h"

@implementation ELRangedKnob

- (id)initWithName:(NSString *)_name_
           minimum:(float)_minimum_
           maximum:(float)_maximum_
          stepping:(float)_stepping_
        linkedKnob:(ELKnob *)_linkedKnob_
           enabled:(BOOL)_enabled_
         linkValue:(BOOL)_linkValue_
        oscillator:(ELOscillator *)_oscillator_
{
  if( ( self = [super initWithName:_name_
                        linkedKnob:_linkedKnob_
                           enabled:_enabled_
                         linkValue:_linkValue_
                        oscillator:_oscillator_] ) )
  {
    [self setMinimum:_minimum_];
    [self setMaximum:_maximum_];
    [self setStepping:_stepping_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ minimum:(float)_minimum_ maximum:(float)_maximum_ stepping:(float)_stepping_ {
  if( ( self = [super initWithName:_name_] ) ) {
    [self setMinimum:_minimum_];
    [self setMaximum:_maximum_];
    [self setStepping:_stepping_];
  }
  
  return self;
}

@synthesize minimum;
@synthesize maximum;
@synthesize stepping;

- (void)setMinimum:(float)_minimum_ maximum:(float)_maximum_ stepping:(float)_stepping_ {
  [self setMinimum:_minimum_];
  [self setMaximum:_maximum_];
  [self setStepping:_stepping_];
}

@end
