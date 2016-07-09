//
//  AppDelegate.h
//  Stretcher
//
//  Created by Tony Korepanov on 07.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class StretchView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet StretchView *stretchView;
}

-(IBAction)showOpenPanel:(id)sender;

@end

