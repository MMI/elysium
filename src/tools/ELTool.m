//
//  ELTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

#import "ELNoteTool.h"
#import "ELGenerateTool.h"
#import "ELReboundTool.h"
#import "ELAbsorbTool.h"
#import "ELSplitTool.h"
#import "ELSpinTool.h"

NSMutableDictionary *toolMapping = nil;

int randval() {
  return ( random() % 100 ) + 1;
}

// double randval() {
//   return ((double)random()) / RAND_MAX;
// }

@implementation ELTool

+ (ELTool *)toolAlloc:(NSString *)_key_ {
  Class toolClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Tool", [_key_ capitalizedString]] );
  ELTool *tool = [toolClass alloc];
  return tool;
}

- (id)init {
  return [self initEnabled:YES
                     pKnob:[[ELIntegerKnob alloc] initWithName:@"p" integerValue:100 minimum:0 maximum:100 stepping:1]
                  gateKnob:[[ELIntegerKnob alloc] initWithName:@"gate" integerValue:0 minimum:0 maximum:32 stepping:1]
                   scripts:[NSMutableDictionary dictionary]];
}

- (id)initEnabled:(BOOL)_enabled_ pKnob:(ELIntegerKnob *)_pKnob_ gateKnob:(ELIntegerKnob *)_gateKnob_ scripts:(NSMutableDictionary *)_scripts_ {
  if( ( self = [super init] ) ) {
    enabled  = _enabled_;
    pKnob    = _pKnob_;
    gateKnob = _gateKnob_;
    scripts  = _scripts_;
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabled:[self enabled]
                                                    pKnob:[[self pKnob] mutableCopy]
                                                 gateKnob:[[self gateKnob] mutableCopy]
                                                  scripts:[[self scripts] mutableCopy]];
}

// Properties

@synthesize hex;
@synthesize layer;

@synthesize enabled;
@synthesize skip;
@synthesize fired;

@synthesize pKnob;
@synthesize gateKnob;

@synthesize scripts;

- (NSString *)toolType {
  [self doesNotRecognizeSelector:_cmd];
  return @"unknown";
}

- (NSArray *)observableValues {
  return [NSArray arrayWithObjects:@"enabled",@"pKnob.value",@"gateKnob.value",nil];
}

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  layer = _layer_;
  hex   = _hex_;
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  layer = nil;
  hex = nil;
}

- (void)start {
  [gateKnob start];
  gateCount = [gateKnob dynamicValue];
}

// Tool-run protocol. The layer will call run and, as long as the tool is enabled,
// the tool will invoke it's scripts and the subclass overriden runTool between them.
- (void)run:(ELPlayhead *)_playhead_ {
  if( enabled ) {
    [self performSelectorOnMainThread:@selector(runWillRunScript:) withObject:_playhead_ waitUntilDone:YES];
    if( gateCount > 0 ) {
      gateCount--;
    } else {
      fired = NO;
      if( !skip ) {
        if( randval() <= [pKnob value] ) {
          [self runTool:_playhead_];
          fired = YES;
        }
      }
      skip = NO;
      
      gateCount = [gateKnob dynamicValue];
    }
    
    [self performSelectorOnMainThread:@selector(runDidRunScript:) withObject:_playhead_ waitUntilDone:YES];
  }
}

// Should be overridden by tool subclasses
- (void)runTool:(ELPlayhead *)_playhead_ {
  [self doesNotRecognizeSelector:_cmd];
}

// Scripting

- (void)runWillRunScript:(ELPlayhead *)_playhead_ {
  [[scripts objectForKey:@"willRun"] evalWithArg:[layer player] arg:self arg:_playhead_];
}

- (void)runDidRunScript:(ELPlayhead *)_playhead_ {
  [[scripts objectForKey:@"didRun"] evalWithArg:[layer player] arg:self arg:_playhead_];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSLog( @"Drawing has not been defined for tool class %@", [self className] );
}

- (void)setToolDrawColor:(NSDictionary *)_attributes_ {
  if( enabled ) {
    [[_attributes_ objectForKey:ELDefaultToolColor] set];
  } else {
    [[_attributes_ objectForKey:ELDisabledToolColor] set];
  }
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *toolElement = [NSXMLNode elementWithName:[self toolType]];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[[NSNumber numberWithBool:enabled] stringValue] forKey:@"enabled"];
  [toolElement setAttributesAsDictionary:attributes];
  
  [toolElement addChild:[self controlsXmlRepresentation]];
  [toolElement addChild:[self scriptsXmlRepresentation]];
  return toolElement;
}

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[pKnob xmlRepresentation]];
  [controlsElement addChild:[gateKnob xmlRepresentation]];
  return controlsElement;
}

- (NSXMLElement *)scriptsXmlRepresentation {
  NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  
  for( NSString *name in [scripts allKeys] ) {
    NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];

    [attributes removeAllObjects];
    [attributes setObject:name forKey:@"name"];
    [scriptElement setAttributesAsDictionary:attributes];
    
    NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
    [cdataNode setStringValue:[scripts objectForKey:name]];
    [scriptElement addChild:cdataNode];
    
    [scriptsElement addChild:scriptElement];
  }
  
  return scriptsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self init] ) ) {
    loaded = YES;
    
    [self setEnabled:([[[_representation_ attributeForName:@"enabled"] stringValue] boolValue])];
    
    NSArray *nodes;
    NSXMLElement *element;
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='p']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        pKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
        [pKnob setMinimum:0 maximum:100 stepping:1];
      } else {
        pKnob = [[ELIntegerKnob alloc] initWithName:@"p" integerValue:100 minimum:0 maximum:100 stepping:1];
      }
      
      if( pKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='gate']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        gateKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
        [gateKnob setMinimum:0 maximum:32 stepping:1];
      } else {
        gateKnob = [[ELIntegerKnob alloc] initWithName:@"gate" integerValue:0 minimum:0 maximum:32 stepping:1];
      }
      
      if( pKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    for( NSXMLNode *node in [_representation_ nodesForXPath:@"scripts/script" error:nil] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      [scripts setObject:[[element stringValue] asJavascriptFunction]
                  forKey:[[element attributeForName:@"name"] stringValue]];
    }
    
  }
  
  return self;
}

- (ELScript *)script:(NSString *)_scriptName_ {
  ELScript *script = [scripts objectForKey:_scriptName_];
  if( script == nil ) {
    script = [[NSString stringWithFormat:@"function(player,token,playhead) {\n\t// write your callback code here\n}\n"] asJavascriptFunction];
    [scripts setObject:script forKey:_scriptName_];
  }
  return script;
}

- (void)removeScript:(NSString *)_scriptName_ {
  [scripts removeObjectForKey:_scriptName_];
}

@end
