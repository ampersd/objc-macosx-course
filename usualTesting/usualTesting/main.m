//
//  main.m
//  usualTesting
//
//  Created by Tony Korepanov on 03.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject{
    NSString *name; // Хотим наблюдать за переменной name
}
@end

@implementation Person

-(id) init {
    if (self = [super init]){ // инициализируем суперкласс
        [self addObserver:self forKeyPath:@"name" options:0 context:@"nameChanged"];
        // добавляем наблюдателя (себя же) за переменной name, опции пока не трогаем, контекст - то, что получает наблюдатель каждый раз при изменении переменной
    }
    return self;
}

// реализуем данный метод, чтобы Key-Value Observing заработал
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"Name is changed to %@", name);
}

// этот метод нужен, чтобы избежать ошибок, когда объект удален, но все еще записан как наблюдатель
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"name"];
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p = [[Person alloc] init];
        [p setValue:@"Anton" forKey:@"name"]; // тестируем наш метод
    }
    return 0;
}
