//
//  BigLetterView.h
//  KeyBorat
//
//  Created by Tony Korepanov on 07.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView {
    NSColor *bgColor;
    NSString *string;
    
    NSMutableDictionary *attr;
    
    NSEvent *mouseDownEvent;
}

-(IBAction)savePDF:(id)sender;

-(IBAction)cut:(id)sender;
-(IBAction)copy:(id)sender;
-(IBAction)paste:(id)sender;

-(void)prepareAttributes; // этот метод будет задавать атрибуты по-умолчанию, когда приложение будет стартовать

@property (strong) NSColor *bgColor;
@property (copy) NSString *string;

@end
