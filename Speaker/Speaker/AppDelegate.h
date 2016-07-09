//
//  AppDelegate.h
//  Speaker
//
//  Created by Tony Korepanov on 02.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate>{
    NSSpeechSynthesizer *speaker;
    NSArray *voices;
}
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)speakIt:(id)sender;
- (IBAction)stopIt:(id)sender;
@end

