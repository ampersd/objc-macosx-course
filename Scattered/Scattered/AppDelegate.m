//
//  AppDelegate.m
//  Scattered
//
//  Created by Tony Korepanov on 09.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
-(void)addImagesFromFolderURL:(NSURL*)url; // будет загружать картинки из папки
-(NSImage*)thumbImageFromImage:(NSImage*)image; // будет принимать большую картинку и возвращать миниатюру
-(void)presentImage:(NSImage*)image; // будет показывать картинку
-(void)setText:(NSString*)text;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // будем размещать картинки в случайном порядке - инициализируем для этого генератор случайных чисел
    srandom((unsigned)time(NULL)); // в качестве источника используем данные из системных часов
    view.layer = [CALayer layer]; // первый слой - хостер, в нём будут находиться другие слои
    // layer внутри содержит стандартные alloc и init
    [view setWantsLayer:YES];
    CALayer *textContainer = [CALayer layer];
    textContainer.anchorPoint = CGPointZero;
    textContainer.position = CGPointMake(10,10);
    textContainer.zPosition = 100;
    textContainer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    textContainer.borderColor = CGColorGetConstantColor(kCGColorWhite);
    textContainer.borderWidth = 2.0;
    textContainer.cornerRadius = 15;
    [view.layer addSublayer:textContainer];
    
    textLayer = [CATextLayer layer];
    textLayer.anchorPoint = CGPointZero;
    textLayer.position = CGPointMake(10, 6);
    textLayer.zPosition = 100;
    textLayer.fontSize = 24;
    textLayer.foregroundColor = CGColorGetConstantColor(kCGColorWhite);
    [textContainer addSublayer:textLayer];
    
    [self setText:@"Loading..."];
    [self addImagesFromFolderURL:[NSURL fileURLWithPath:@"/Library/Desktop Pictures"]];
}

-(void)setText:(NSString *)text{
    NSFont *font = [NSFont systemFontOfSize:textLayer.fontSize];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    NSSize size = [text sizeWithAttributes:attrs];
    
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    
    textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    textLayer.superlayer.bounds = CGRectMake(0, 0, size.width + 16, size.height + 20);
    textLayer.string = text;
}

-(NSImage *)thumbImageFromImage:(NSImage *)image {
    const CGFloat targetHeight = 200.0f;
    NSSize imageSize = [image size];
    NSSize smallerSize = NSMakeSize(targetHeight * imageSize.width / imageSize.height, targetHeight);
    
    NSImage *smallerImage = [[NSImage alloc]initWithSize:smallerSize];
    [smallerImage lockFocus]; // lockFocus позволяет подготовить изображения для того, чтобы мы могли записывать в него
    [image drawInRect:NSMakeRect(0, 0, smallerSize.width, smallerSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    
    [smallerImage unlockFocus];
    return smallerImage;
}

-(void) addImagesFromFolderURL:(NSURL *)url {
    NSTimeInterval t0 = [NSDate timeIntervalSinceReferenceDate];
    NSFileManager *fileManager = [NSFileManager new]; // new - не ключевое слово, а метод класса
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil]; // обработку ошибок в этот раз пропускаем
    
    int allowedFiles = 10;
    for (NSURL *insideUrl in dirEnum) {
        NSNumber *isDirectory = nil;
        [insideUrl getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        if ([isDirectory boolValue]) continue;
        
        NSImage *image = [[NSImage alloc]initWithContentsOfURL:insideUrl];
        if (!image) return;
        
        allowedFiles--;
        if (allowedFiles < 0) break;
        
        NSImage *thumbImage = [self thumbImageFromImage:image];
        [self presentImage:thumbImage];
        [self setText:[NSString stringWithFormat:@"% 0.1fs",[NSDate timeIntervalSinceReferenceDate] - t0]];

    }
}

-(void)presentImage:(NSImage *)image {
    CGRect superLayerBounds= view.layer.bounds;
    NSPoint center = NSMakePoint(CGRectGetMidX(superLayerBounds), CGRectGetMidY(superLayerBounds));
    NSRect imageBounds = NSMakeRect(0, 0, image.size.width, image.size.height);
    CGPoint randomPoint = CGPointMake(CGRectGetMaxX(superLayerBounds) * (double)random() / (double)RAND_MAX, CGRectGetMaxY(superLayerBounds) * (double)random() / (double)RAND_MAX);
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *posAnim = [CABasicAnimation animation]; // position Animation - анимация, отвечающая за позицию
    
    posAnim.fromValue = [NSValue valueWithPoint:center];
    posAnim.duration = 1.5; // длительность анимации
    posAnim.timingFunction = tf;
    
    CABasicAnimation *bdsAnim = [CABasicAnimation animation];
    bdsAnim.fromValue = [NSValue valueWithRect:NSZeroRect]; // будет начинаться с нижнего левого угла
    bdsAnim.duration = 1.5;
    bdsAnim.timingFunction = tf;
    
    CALayer *layer = [CALayer layer];
    layer.contents = image;
    layer.actions = [NSDictionary dictionaryWithObjectsAndKeys:posAnim, @"position", bdsAnim, @"bounds", nil];
    
    [CATransaction begin];
    // всё что находится между begin и commit будет считаться за один шаг анимации
    [view.layer addSublayer:layer];
    layer.position = randomPoint;
    layer.bounds = NSRectToCGRect(imageBounds);
    [CATransaction commit];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
