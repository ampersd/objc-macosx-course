//
//  AppDelegate.h
//  UpcomingClasses
//
//  Created by Tony Korepanov on 08.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSTableView *tableView;
    NSArray *classes;
}


@end

