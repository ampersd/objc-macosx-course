//
//  BigLetterView.m
//  KeyBorat
//
//  Created by Tony Korepanov on 07.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "BigLetterView.h"

@implementation BigLetterView

-(id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // цвет по-умолчанию
        bgColor = [NSColor blueColor];
        string = @"";
        [self prepareAttributes];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    NSRect bound = [self bounds];
    [bgColor set];
    [NSBezierPath fillRect:bound];
    // нужно проверить, являемся ли мы (BigLetterView) текущим объектом, реагирующим на события клавиатуры - т.е. First Responder'ом
    if ([[self window]firstResponder] == self) {
        [[NSColor keyboardFocusIndicatorColor]set];
        [NSBezierPath setDefaultLineWidth:5.0];
        [NSBezierPath strokeRect:bound];
    }
    [self drawStringCenteredIn:bound];
}

-(BOOL)isOpaque {return YES;} // является ли наш вид Opaque?
-(BOOL)acceptsFirstResponder {return YES;} // может ли наш View принимать статус "First Responder"
-(BOOL)resignFirstResponder {return YES;} // вызывается каждый раз, когда статус пытается уйти от текущего объекта
-(BOOL)becomeFirstResponder {return YES;} // вызывается когда текущий объект становится  "First Responder"

-(void)keyDown:(NSEvent *)theEvent {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

-(void)insertText:(id)insertString {
    [self setString:insertString];
}

// хотим, чтобы при нажатии Tab фокус переходил по кругу, против часовой стрелки - нужен метод для обработки Tab'a
-(void)insertTab:(id)sender {
    // указываем следующий фокус
    [[self window]selectKeyViewFollowingView:self];
}


-(void)setBgColor:(NSColor *)newColor {
    bgColor = newColor;
    [self setNeedsDisplay:YES];
}

-(NSColor*)bgColor {
    return bgColor;
}

-(void)setString:(NSString *)s{
    string = s;
    NSLog(@"%@", string);
    [self setNeedsDisplay:YES];
}

-(NSString*)string {
    return string;
}

-(void)drawStringCenteredIn:(NSRect)r {
    NSSize strSize = [string sizeWithAttributes:attr];
    NSPoint strOrigin;
    strOrigin.x = r.origin.x + (r.size.width - strSize.width)/2;
    strOrigin.y = r.origin.y + (r.size.height - strSize.height)/2;
    [string drawAtPoint:strOrigin withAttributes:attr];
}

-(void)prepareAttributes {
    attr = [NSMutableDictionary dictionary];
    [attr setObject:[NSFont userFontOfSize:80] forKey:NSFontAttributeName];
    [attr setObject:[NSColor yellowColor] forKey:NSForegroundColorAttributeName];
    
}

-(IBAction)savePDF:(id)sender {
    __block NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if(result == NSOKButton) {
            NSRect r = [self bounds];
            NSData *data = [self dataWithPDFInsideRect:r];
            NSError *error;
            BOOL successful = [data writeToURL:[panel URL] options:0 error:&error];
            if (!successful){
                NSAlert *a = [NSAlert alertWithError:error];
                [a runModal]; // показываем сообщение об ошибке, если оно есть
            }
        }
        panel = nil;
    }];
    
}

// реализация буфера обмена ================

-(void) writeToPasteboard:(NSPasteboard*)pb {
    [pb clearContents];
    [pb writeObjects:[NSArray arrayWithObject:string]]; // string - это наш объект с текстом
}

-(BOOL)readFromPasteboard: (NSPasteboard*)pb {
    // хотим читать из буфера обмена исключительно NSString, берём его класс
    NSArray *classes = [NSArray arrayWithObject:[NSString class]];
    NSArray *objects = [pb readObjectsForClasses:classes options:nil];
    if ([objects count] > 0) {
        NSString *value = [objects objectAtIndex:0];
        if ([value length] == 1) { // если длина строки - 1 символ, то устанавливаем его нашему Custom View
            // мы здесь работаем очень топорно, по-хорошему надо просто каждый раз брать первый символ
            [self setString:value];
            return YES;
        }
    }
    return NO;
}

-(IBAction)cut:(id)sender {
    [self copy:sender];
    [self setString:@""];
}

-(IBAction)copy:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [self writeToPasteboard:pb]; // говорим - сделай то, что ты обычно делаешь когда мы тебе говорим "записать в Pasteboard
}

-(IBAction)paste:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [self readFromPasteboard:pb];
}

// =========================================

-(void)mouseDown:(NSEvent *)theEvent {
    mouseDownEvent = theEvent;
}

-(void)mouseDragged:(NSEvent *)theEvent {
    // координаты, где мышь была зажата
    NSPoint down = [mouseDownEvent locationInWindow];
    // координаты, куда мышь была перенесена
    NSPoint drag = [theEvent locationInWindow];
    float distance = hypot(down.x - drag.x, down.y - drag.y);
    // если расстояние перетаскивания меньше 3-х или если длина строки нашей нулевая, то выходим из функции
    if (distance < 3 || [string length] == 0) {return;}
    
    NSSize s = [string sizeWithAttributes:attr];
    // хотим, чтобы символ, который мы перетягиваем - отображался как картинка и следовал за курсором
    NSImage *anImage = [[NSImage alloc]initWithSize:s];
    NSRect imageBounds;
    imageBounds.origin = NSZeroPoint;
    imageBounds.size = s;
    [anImage lockFocus];
    [self drawStringCenteredIn:imageBounds];
    [anImage unlockFocus];
    
    // нужно получить координаты того места, где пользователь отпускает кнопку мыши
    NSPoint p = [self convertPoint:down fromView:nil];
    p.x = p.x - s.width/2;
    p.y = p.y - s.height/2;
    
    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
    [self writeToPasteboard:pb];
    [self dragImage:anImage at:p offset:NSZeroSize event:mouseDownEvent pasteboard:pb source:self slideBack:YES];
    // slideBack - вернёт изображение обратно, если его некуда будет вставить в том месте, куда мы перетаскиваем
}

@end
