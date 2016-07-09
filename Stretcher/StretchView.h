//
//  StretchView.h
//  Stretcher
//
//  Created by Tony Korepanov on 07.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView {
    NSBezierPath *path;
    NSImage *image;
    float opacity; // нужно значение от 0 до 1 - прозрачность
    
    NSPoint downPoint; // нажатие на левую кнопку мыши
    NSPoint currentPoint; // куда пользователь тянет мышь
}

// хотим чтобы рисование было случайным - добавим метод, который будет возвращать случайную точку
-(NSPoint) randomPoint;

// assign - тип свойства
@property (assign) float opacity;
// strong - тоже тип свойства, означающий что отношение к объекту у нас сильное, иными словами мы являемся его владельцем
@property (strong) NSImage *image;

@end
