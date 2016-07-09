//
//  PreferencesController.m
//  carShop
//
//  Created by Tony Korepanov on 04.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

NSString *const HEXLTableBgColorKey = @"HEXLTableBgColorKey";
NSString *const HEXLEmptyDocKey = @"HEXLEmptyDocKey";

NSString *const HEXLColorChangeNotification = @"HEXLColorChangeNotification";

// initialize - статичный метод именно класса, а не экземпляра (объекта), вызывается при инициализации самого класса, до того как будет создан любой объект данного класса
+(void)initialize {
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary]; // получаем пустой MutableDictionary
    // в наш словарь мы хотим записывать цвет, но цвет - это NSColor и мы не можем просто сохранить его в словаре
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
    [defaultValues setObject:colorAsData forKey:HEXLTableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:HEXLEmptyDocKey];
    
    // получили объект с настройками через standardUserDefaults и записали туда наши "заводские" настройки
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}



-(id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [colorWell setColor:[PreferencesController preferenceTableBgColor]];
    [checkBox setState:[PreferencesController preferenceEmptyDoc]];
}

-(IBAction)changeBackgroundColor:(id)sender{
    NSColor *color = [colorWell color];
    [PreferencesController setPreferenceTableBgColor:color];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
    [nc postNotificationName:HEXLColorChangeNotification object:self userInfo:d];
}
     
-(IBAction)changeNewEmptyDoc:(id)sender{
    [PreferencesController setPreferenceEmptyDoc:[checkBox state]];
}

+(NSColor *)preferenceTableBgColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:HEXLTableBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

+(void)setPreferenceTableBgColor:(NSColor *)color {
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults]setObject:colorAsData forKey:HEXLTableBgColorKey];
}

+(BOOL)preferenceEmptyDoc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:HEXLEmptyDocKey];
}

+(void)setPreferenceEmptyDoc:(BOOL)emptyDoc{
    [[NSUserDefaults standardUserDefaults]setBool:emptyDoc forKey:HEXLEmptyDocKey];
}
@end
