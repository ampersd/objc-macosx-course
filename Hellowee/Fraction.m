//
//  Fraction.m
//  Hellowee
//
//  Created by Tony Korepanov on 02.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction

-(void) doubleNumber{
    _numerator = _numerator * 2;
    _denominator = _denominator * 2;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%i/%i", _numerator, _denominator];
}

@end
