//
//  ScheduledFetcher.h
//  UpcomingClasses
//
//  Created by Tony Korepanov on 08.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Foundation/Foundation.h>


// добавляем протокол для парсинга XML
@interface ScheduledFetcher : NSObject <NSXMLParserDelegate> {
    NSMutableArray *classes;
    NSMutableString *currentString; // текущая строка для парсинга
    NSMutableDictionary *currentFields;
    NSDateFormatter *dateFormatter;
}

-(NSArray*)fetchClassesWithError:(NSError**)outError;

@end
