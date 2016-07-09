//
//  Fraction.h
//  Hellowee
//
//  Created by Tony Korepanov on 02.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "numbersProtocol.h"

@interface Fraction : NSObject <numbersProtocol>

@property int numerator, denominator;

@end
