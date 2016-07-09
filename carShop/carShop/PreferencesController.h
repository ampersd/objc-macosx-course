//
//  PreferencesController.h
//  carShop
//
//  Created by Tony Korepanov on 04.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const HEXLTableBgColorKey; // extern - C-шное ключевое слово для задания глобальных переменных
extern NSString *const HEXLEmptyDocKey; // Настройку обычно начинают называть с имени компании, HEXL - Hexlet, название компании

extern NSString *const HEXLColorChangeNotification;

@interface PreferencesController : NSWindowController {
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *checkBox;
}

+(NSColor*)preferenceTableBgColor;
+(void)setPreferenceTableBgColor:(NSColor*)color;
+(BOOL)preferenceEmptyDoc;
+(void)setPreferenceEmptyDoc:(BOOL)emptyDoc;

-(IBAction)changeBackgroundColor:(id)sender;
-(IBAction)changeNewEmptyDoc:(id)sender;

@end
