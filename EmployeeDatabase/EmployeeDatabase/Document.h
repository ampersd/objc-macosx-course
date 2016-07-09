//
//  Document.h
//  EmployeeDatabase
//
//  Created by Tony Korepanov on 03.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Person.h"

@interface Document : NSDocument{
    NSMutableArray *employees;
    IBOutlet NSTableView *table;
    IBOutlet NSArrayController *employeesController;
}

-(IBAction)removeEmployees:(id)sender;

-(void) setEmployees:(NSMutableArray *)empl;

-(void)insertObject:(Person*)p inEmployeesAtIndex:(NSInteger) index;
-(void)removeObjectFromEmployeesAtIndex:(NSInteger) index;

@end

