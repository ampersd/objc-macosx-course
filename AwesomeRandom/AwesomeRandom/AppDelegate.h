//
//  AppDelegate.h
//  AwesomeRandom
//
//  Created by Tony Korepanov on 02.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet NSTextField *textField;
}

-(IBAction)generate:(id)sender;
-(IBAction)seed:(id)sender;

@end

