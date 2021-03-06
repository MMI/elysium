//
//  ELLayerManagerWindowController.m
//  Elysium
//
//  Created by Matt Mower on 06/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELLayerManagerWindowController.h"

@implementation ELLayerManagerWindowController

- (id)init {
  if( ( self = [self initWithWindowNibName:@"LayerManager"] ) ) {
    // Custom initialization here
  }
  
  return self;
}

- (void)windowDidLoad {
  [[self window] setTitle:[NSString stringWithFormat:@"%@ - Layer Manager", [[self document] displayName]]];
}

- (void)tableViewSelectionDidChange:(NSNotification *)_notification_ {
  int row = [[_notification_ object] selectedRow];
  if( row == -1 ) {
    return;
  }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)_displayName_ {
  return [NSString stringWithFormat:@"%@ - Layer Manager", _displayName_];
}

@end
