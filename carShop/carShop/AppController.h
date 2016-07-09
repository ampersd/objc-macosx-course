//
//  AppController.h
//  carShop
//
//  Created by Tony Korepanov on 04.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

// вместо import "PreferencesController.h" используем @class, т.к. нам не важны методы и поля в нем, мы просто говорим компилятору: "Поверь мне, такой класс существует"
@class PreferencesController;

@interface AppController : NSObject {
    PreferencesController *preferences; // тут мы можем указать данный класс
}

-(IBAction)showPreferences:(id)sender;

@end
