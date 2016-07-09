//
//  AppDelegate.m
//  AwesomeRandom
//
//  Created by Tony Korepanov on 02.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)seed:(id)sender{
    srandom((unsigned)time(NULL));
}

- (IBAction)generate:(id)sender{
    int num = (int)((random() % 100) + 1);
    [textField setIntValue:num];
}
@end
