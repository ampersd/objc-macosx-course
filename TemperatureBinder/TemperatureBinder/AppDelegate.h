//
//  AppDelegate.h
//  TemperatureBinder
//
//  Created by Tony Korepanov on 03.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSInteger temperature;
    NSUndoManager *undoManager;
}
@property (weak) IBOutlet NSTextField *label;

- (IBAction)increment:(id)sender;

-(IBAction)makeItHotter:(id)sender;
-(IBAction)makeItColder:(id)sender;
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;


@end

