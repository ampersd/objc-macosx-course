//
//  StretchView.m
//  Stretcher
//
//  Created by Tony Korepanov on 07.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

-(id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // Initialization code here.
        opacity = 1.0;
        // инициализируем генератор случайных чисел с помощью текущего времени
        srandom((unsigned)time(NULL));
        path = [NSBezierPath bezierPath];
        [path setLineWidth:3.0]; // зададим толщину
        NSPoint p = [self randomPoint];
        [path moveToPoint:p];
        int i;
        for (i = 0;i < 14;i++) { // 14 линий
            p = [self randomPoint];
            [path lineToPoint:p];
        }
        [path closePath];
    }
    return self;
}

// Геттеры и сеттеры============
-(float) opacity {
    return opacity;
}

-(void)setOpacity:(float)x {
    opacity = x;
    // перерисовываем интерфейс
    [self setNeedsDisplay:YES];
}

-(NSImage*)image {
    return image;
}

-(void)setImage:(NSImage *)newImage{
    image = newImage;
    NSSize imageSize = [newImage size];
    downPoint = NSZeroPoint;
    currentPoint.x = downPoint.x + imageSize.width;
    currentPoint.y = downPoint.y + imageSize.height;
    // перерисовываем интерфейс
    [self setNeedsDisplay:YES];
}


//==============================

- (NSPoint)randomPoint {
    NSPoint result;
    NSRect r = [self bounds]; // надо знать в пределах чего мы будем создавать случайную точку
    result.x = r.origin.x + random() % (int)r.size.width;
    result.y = r.origin.y + random() % (int)r.size.height;
    return result;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    
    // перво-наперво определим границы нашего вида, чтобы не выходить за него когда мы рисуем
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set]; // просим задать цвет, который мы будем использовать
    [NSBezierPath fillRect:bounds]; // хотим использовать кривую Безье
    [[NSColor whiteColor]set];
    [path stroke]; // соединяем путь
    // [path fill] - можно использовать тоже - заполним путь
    
    if (image) {
        NSRect imageRect;
        imageRect.origin = NSZeroPoint; // поместим нашу картинку в начало координат, т.е. в нижний левый угол
        imageRect.size = [image size];
        //NSRect drawingRect = imageRect;
        // imageRect нам по сути не нужен
        NSRect drawingRect = [self currentRect];
        // NSCompositeSourceOver - наложим наше изображение сверху
        // opacity - собственно в этом месте мы и используем это значение
        [image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:opacity];
    }
}


// т.к. наследуем от NSView, который наследует от NSResponder - можем реализовать методы работы с мышью здесь
-(void)mouseDown:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    downPoint = [self convertPoint:p toView:nil]; // nil - говорит о том, что мы хотим сконвертировать из окна window
    currentPoint = downPoint;
    [self setNeedsDisplay:YES];
}

// при нажатой клавише передвигается
-(void)mouseDragged:(NSEvent *)theEvent{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p toView:nil];
    [self setNeedsDisplay:YES];
}

// пользователь отпускает кнопку мыши
-(void)mouseUp:(NSEvent *)theEvent{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p toView:nil];
    [self setNeedsDisplay:YES];
}

// этот метод будет возвращать созданный прямоугольник, который мы с помощью мыши задаём
-(NSRect)currentRect {
    float minX = MIN(downPoint.x, currentPoint.x);
    float maxX = MAX(downPoint.x, currentPoint.x);
    float minY = MIN(downPoint.y, currentPoint.y);
    float maxY = MAX(downPoint.y, currentPoint.y);
    return NSMakeRect(minX, minY, maxX, maxY);
}






@end
