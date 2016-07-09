//
//  AppDelegate.m
//  Speaker
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
    speaker = [[NSSpeechSynthesizer alloc] initWithVoice:NULL]; // получить голос по-умолчанию
    [speaker setDelegate:self];
    voices = [NSSpeechSynthesizer availableVoices];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)speakIt:(id)sender {
    [speaker startSpeakingString:[_textField stringValue]];
}

- (IBAction)stopIt:(id)sender {
    [speaker stopSpeaking];
}

-(void) tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger row = [_tableView selectedRow];
    if(row == -1) { return; }
    NSString *selectedVoice = [voices objectAtIndex:row];
    [speaker setVoice:selectedVoice];
}

-(void) speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {
    [_textField setStringValue:@""];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *) tv{
    return (NSInteger)[[NSSpeechSynthesizer availableVoices] count];
}

-(id)tableView:(NSTableView *) tv objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *v = [[NSSpeechSynthesizer availableVoices] objectAtIndex:row];
    return v;
}

@end
