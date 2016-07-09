//
//  main.m
//  Hellowee
//
//  Created by Tony Korepanov on 02.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@interface Fraction (MathOps)
-(void)add: (Fraction *) f;
@end

@implementation Fraction (MathOps)
-(void)add: (Fraction *) f {
    [self setNumerator: self.numerator * f.denominator + self.denominator * f.numerator];
    [self setDenominator: self.denominator * f.denominator];
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Fraction *myFraction, *myFraction2;
        myFraction = [[Fraction alloc] init];
        myFraction2 = [[Fraction alloc] init];
        
        // вызываем методы
        [myFraction setNumerator:10];
        [myFraction setDenominator:22];
        
        [myFraction2 setNumerator:5];
        [myFraction2 setDenominator:6];
        
        [myFraction add: myFraction2];
        
//        [myFraction print];
        NSLog(@"%@", myFraction);
    }
    return 0;
}
