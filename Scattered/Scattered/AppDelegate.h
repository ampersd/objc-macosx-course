//
//  AppDelegate.h
//  Scattered
//
//  Created by Tony Korepanov on 09.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSView *view;
    CATextLayer *textLayer; // CA - Core Animation
}


@end

