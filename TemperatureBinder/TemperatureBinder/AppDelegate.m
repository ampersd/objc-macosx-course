//
//  AppDelegate.m
//  TemperatureBinder
//
//  Created by Tony Korepanov on 03.07.16.
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

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:[NSNumber numberWithInteger:0] forKey:@"temperature"];
        undoManager = [[self window] undoManager];
    }
    return self;
}

-(void)setTemperature:(int) x {
    [_label setStringValue:[NSString stringWithFormat:@"%d", x]];
    temperature = x;
}

-(int)temperature {
    return (int)temperature;
}

- (IBAction)increment:(id)sender {
    [self willChangeValueForKey:@"temperature"];
    [self setTemperature:[self temperature] + 1];
    [self didChangeValueForKey:@"temperature"];
}

- (IBAction)makeItHotter:(id)sender {
    [self hotter];
}

- (IBAction)makeItColder:(id)sender {
    [self colder];
}

-(void)hotter {
    [self setTemperature: [self temperature] + 10];
    [[undoManager prepareWithInvocationTarget:self] colder];
    if(![undoManager isUndoing])
    {
        [undoManager setActionName:@"Hotter"];
    }
}

-(void)colder {
    [self setTemperature: [self temperature] - 10];
    [[undoManager prepareWithInvocationTarget:self] hotter];
    if(![undoManager isUndoing])
    {
        [undoManager setActionName:@"Colder"];
    }
}

- (IBAction)undo:(id)sender {
    [undoManager undo];
    NSLog(@"undo");
}

- (IBAction)redo:(id)sender {
    [undoManager redo];
    NSLog(@"redo");
}
@end
