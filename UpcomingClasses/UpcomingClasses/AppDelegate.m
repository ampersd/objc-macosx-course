//
//  AppDelegate.m
//  UpcomingClasses
//
//  Created by Tony Korepanov on 08.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "AppDelegate.h"
#import "ScheduledFetcher.h"
#import "ScheduledClass.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(openClass:)];
    
    ScheduledFetcher *fetcher = [[ScheduledFetcher alloc]init];
    NSError *error = nil;
    classes = [fetcher fetchClassesWithError:&error];
    [tableView reloadData];
    
}

-(void)openClass:(id)sender {
    ScheduledClass *c = [classes objectAtIndex:[tableView clickedRow]];
    NSURL *baseURL = [NSURL URLWithString:@"http://bignerdranch.com/"];
    NSURL *url = [NSURL URLWithString:[c href] relativeToURL:baseURL];
    
    [[NSWorkspace sharedWorkspace] openURL:url]; // просим наше рабочее приложение запустить браузер по-умолчанию
}

// как только мы вызываем [tableView reloadData], первым делом tableView вызывает этот метод, чтобы узнать сколько создать строчек. На самом деле theTableView аргумент нам даже не нужен
-(NSInteger)numberOfRowsInTableView: (NSTableView*)theTableView {
    return [classes count];
}

// это второе, что будет вызывать [tableView reloadData],
-(id)tableView:(NSTableView*)theTableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    ScheduledClass *c = [classes objectAtIndex:row];
    return [c valueForKey:[tableColumn identifier]]; // идентификаторы мы добавили к колонкам так, чтобы они были аналогичны названиям полей в ScheduledClass
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
