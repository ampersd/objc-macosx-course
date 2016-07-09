//
//  AppDelegate.m
//  Stretcher
//
//  Created by Tony Korepanov on 07.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "AppDelegate.h"
#import "StretchView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)showOpenPanel:(id)sender {
    // обычно переменная, которая попадает внутрь блока - копируется туда. Если мы не хотим этого, а хотим использовать ту же переменную - то используем ключевое слово __block
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    // хотим открывать только картинки
    [panel setAllowedFileTypes: [NSImage imageFileTypes]];
    
    // ^ - обозначение блока, в отличие от функции блок является замыканием - имеет доступ к переменным, созданным на уровень выше, будет хранить ссылки на все переменные даже после того как сама внешняя функция отработает.
    // т.е. блок - это местное лямбда-выражение
    [panel beginSheetModalForWindow:[stretchView window] completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSImage *image = [[NSImage alloc]initWithContentsOfURL:[panel URL]];
            [stretchView setImage:image];
        }
        panel = nil; // здесь нашу панельку уже можно уничтожить
    }];
}

@end
