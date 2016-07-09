//
//  ScheduledClass.h
//  UpcomingClasses
//
//  Created by Tony Korepanov on 08.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduledClass : NSObject

// имя курса
@property NSString *name;
// физическое место, где он проходит
@property NSString *location;
// страничка курса в интернете
@property NSString *href;
// дата начала курса
@property NSDate *begin;

@end
