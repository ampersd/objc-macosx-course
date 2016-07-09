//
//  AppController.m
//  carShop
//
//  Created by Tony Korepanov on 04.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "AppController.h"
#import "PreferencesController.h" // тут нам потребуется полноценный import

@implementation AppController

-(BOOL)applicationShouldOpenUntitledFile:(NSApplication*)sender{
    return [PreferencesController preferenceEmptyDoc];
}

-(IBAction)showPreferences:(id)sender {
    if (!preferences) {
        preferences = [[PreferencesController alloc] init];
    }
    [preferences showWindow:self];
}

@end
