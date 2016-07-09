//
//  Person.m
//  EmployeeDatabase
//
//  Created by Tony Korepanov on 03.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import "Person.h"

@implementation Person

-(id) init {
    if (self = [super init]){
        _name = @"Unnamed Person";
        _raise = 0.1;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    // здесь мы выбираем именно те части, которые мы хотим закодировать
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeFloat:_raise forKey:@"raise"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _raise = [aDecoder decodeFloatForKey:@"raise"];
    }
    return self;
}

@end
