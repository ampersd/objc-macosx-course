//
//  Document.h
//  carShop
//
//  Created by Tony Korepanov on 04.07.16.
//  Copyright © 2016 Anton Korepanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSPersistentDocument {
    IBOutlet NSTableView *table;
}

@end
