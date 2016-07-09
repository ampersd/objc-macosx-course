//
//  ScheduledFetcher.m
//  UpcomingClasses
//
//  Created by Tony Korepanov on 08.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import "ScheduledFetcher.h"
#import "ScheduledClass.h"

@implementation ScheduledFetcher
-(id)init{
    self = [super init];
    if (self) {
        classes = [[NSMutableArray alloc]init];
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    }
    return self;
}

-(NSArray*)fetchClassesWithError:(NSError *__autoreleasing *)outError {
    BOOL success;

    NSURL *xmlURL = [NSURL URLWithString:@"http://bignerdranch.com/xml/schedule"];
    // NSURLRequestReturnCacheDataElseLoad - всегда будем получать данные с кэша независимо от срока давности, если данных в кэше нет, то данные загрузятся из источника и поместятся в кэш
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *resp = nil;
    
    // следующая строчка сделает запрос
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:outError];
    if (!data) return nil;
//    NSLog(@"%Recieved %ld bytes.", [data length]);
//    return nil;
    // если дошли до этой строчки - значит у нас есть данные
    [classes removeAllObjects]; // очищаем список уроков, если там что-то было
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self]; // сделаем делегатом этого парсера наш файл
    // теперь остается начать парсинг, парсер будет вызывать методы делегата, т.е. нашего класса
    success = [parser parse]; // если что-то будет не так, то метод вернет NO
    if (!success) {
        *outError = [parser parserError];
        return nil;
    }
    NSArray *output = [classes copy]; // classes - NSMutableArray, мы хотим вернуть неизменяемый массив
    return output; // возвращаем неизменяемый массив
}

// методы, которые парсер будет вызывать

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqual:@"class"]) {// как только находим элемент вида ...<class>...
        currentFields = [[NSMutableDictionary alloc]init];
    } else if ([elementName isEqual:@"offering"]) {
        // берём значение href из словаря attributeDict и вставляем в currentFields
        [currentFields setObject:[attributeDict objectForKey:@"href"] forKey:@"href"];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqual:@"class"]) {
        ScheduledClass *currentClass = [[ScheduledClass alloc]init];
        [currentClass setName:[currentFields objectForKey:@"offering"]];
        [currentClass setLocation:[currentFields objectForKey:@"location"]];
        [currentClass setHref:[currentFields objectForKey:@"href"]];
        
        NSString *beginString = [currentFields objectForKey:@"begin"];
        NSDate *beginDate = [dateFormatter dateFromString:beginString];
        [currentClass setBegin:beginDate];
        [classes addObject:currentClass];
        // создали объект и добавили его в classes
        
        currentClass = nil; // всё это нам больше не понадобится
        currentFields = nil;
    } else if (currentFields && currentString) {
        NSString *trimmed;
        // всё что начинается с пробела или с новой строки будет взято как отдельный string
        trimmed = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [currentFields setObject:trimmed forKey:elementName];
    }
    currentString = nil; // чтобы условие "currentFields && currentString" в следующий раз не выполнилось
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentString) { // если currentString - nil, то...
        currentString = [[NSMutableString alloc]init];
    }
    [currentString appendString:string];
}

@end
