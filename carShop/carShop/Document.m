//
//  Document.m
//  carShop
//
//  Created by Tony Korepanov on 04.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "Document.h"
#import "PreferencesController.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(handleColorChange:) name:HEXLColorChangeNotification object:nil];
    }
    return self;
}

// dealloc - отличное место для того чтобы удалить себя из списка наблюдателей
- (void) dealloc {
    //[super dealloc]; - нам этого делать не нужно, т.к. включен автоматический подсчёт ссылок
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void) handleColorChange:(NSNotification*)notif {
    NSColor *color = [[notif userInfo] objectForKey:@"color"];  // userInfo - это то, что не обязательно передавать вместе с сообщением, любая пользовательская информация
    // можем передать какой-нибудь объект или, скажем, значение
    [table setBackgroundColor:color];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

-(void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    [table setBackgroundColor:[PreferencesController preferenceTableBgColor]];
}

@end
