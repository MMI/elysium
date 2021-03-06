//
//  ELTimerCallback.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELTimerCallback.h"

#import "ELPlayer.h"

@implementation ELTimerCallback

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [super init] ) ) {
    player = _player_;
    active = NO;
    interval = 30.0;
    timer = nil;
    callback = [@"function(player,timer) {\n\t// Write your callback here\n}\n" asJavascriptFunction];
    
    [self addObserver:self forKeyPath:@"active" options:0 context:nil];
  }
  
  return self;
}

@synthesize active;
@synthesize interval;
@synthesize callback;
@synthesize player;

- (void)observeValueForKeyPath:(NSString *)_keyPath_ ofObject:(id)_object_ change:(NSDictionary *)_change_ context:(id)_context_ {
  if( [_keyPath_ isEqualToString:@"active"] ) {
    if( [self active] ) {
      timer = [NSTimer timerWithTimeInterval:[self interval] target:self selector:@selector(runCallback:) userInfo:nil repeats:YES];
      [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } else {
      [timer invalidate];
    }
  }
}

- (void)runCallback:(NSTimer *)_timer_ {
  NSLog( @"Timer has fired." );
  [callback evalWithArg:[self player] arg:self];
}

// ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self initWithPlayer:_player_] ) ) {
    
    [self setInterval:[[[_representation_ attributeForName:@"interval"] stringValue] doubleValue]];
    
    NSXMLElement *scriptElement = (NSXMLElement *)[[_representation_ nodesForXPath:@"script" error:nil] objectAtIndex:0];
    [[self callback] setSource:[scriptElement stringValue]];
  }
  
  return self;
}

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *timerElement = [NSXMLNode elementWithName:@"timer"];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[NSNumber numberWithDouble:interval] forKey:@"interval"];
  [timerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
  NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
  [cdataNode setStringValue:[callback source]];
  [scriptElement addChild:cdataNode];
  [timerElement addChild:scriptElement];
  
  return timerElement;
}

@end
