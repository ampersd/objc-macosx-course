//
//  Document.m
//  EmployeeDatabase
//
//  Created by Tony Korepanov on 03.07.16.
//  Copyright © 2016 Homie. All rights reserved.
//

#import "Document.h"

//@interface Document ()
//
//@end

static void *RMDocumentKVOContext;

@implementation Document

-(void)startObservingPerson:(Person *)person {
    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [person addObserver:self forKeyPath:@"raise" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

-(void)stopObservingPerson:(Person *)person {
    [person removeObserver:self forKeyPath:@"name"];
    [person removeObserver:self forKeyPath:@"raise"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        employees = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) setEmployees:(NSMutableArray *)empl{
    if (employees != empl){
        for (Person *person in employees) {
            [self stopObservingPerson:person];
        }
        employees = empl;
        for (Person *person in employees) {
            [self startObservingPerson:person];
        }
    }
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    [[table window] endEditingFor:nil];
    return [NSKeyedArchiver archivedDataWithRootObject:employees];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e){
        if(outError) { // передаем ошибку двойному указателю
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The file is invalid" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
            return NO;
        }
    }
    [self setEmployees:newArray];
    return YES;
}

// Alert panels ===============================

-(IBAction)removeEmployees:(id)sender {
    NSArray *selected = [employeesController selectedObjects]; // вернёт массив выделенных объектов
    // теперь мы знаем кого удалять
    NSAlert *alert = [NSAlert
                      alertWithMessageText: NSLocalizedString(@"REMOVE_MSG", "Remove message") // второй аргумент метода - это комментарий, здесь он нам не важен, пусть будет "Remove message"
                      defaultButton:NSLocalizedString(@"REMOVE", "Remove")
                      alternateButton:NSLocalizedString(@"CANCEL", "Cancel")
                      otherButton:nil
                      informativeTextWithFormat:NSLocalizedString(@"REMOVE_INF", "Remove info"), [selected count]];
    [alert beginSheetModalForWindow:[table window] modalDelegate:self didEndSelector:@selector(alertEnded:code:context:) contextInfo:NULL];
    // вызываем созданное нами модальное окно
    // [table window] - берем ссылку на то окно, в котором находится наша таблица
    // didEndSelector - передаем ссылку на метод, который вызовется при закрытии
}

-(void)alertEnded:(NSAlert*)alert code:(NSInteger) choice context:(void*)v {
    if (choice == NSAlertDefaultReturn) {
        [employeesController remove:nil];
    }
}

// ============================================


-(void)insertObject:(Person *)p inEmployeesAtIndex:(NSInteger)index{
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]){
        [undo setActionName:@"Add person"];
    }
    
    [self startObservingPerson:p];
    [employees insertObject:p atIndex:index];
}

-(void)removeObjectFromEmployeesAtIndex:(NSInteger)index{
    NSUndoManager *undo = [self undoManager];
    Person *p = [employees objectAtIndex:index];
    [[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
    if (![undo isUndoing]){
        [undo setActionName:@"Remove person"];
    }
    [self stopObservingPerson:p];
    [employees removeObjectAtIndex:index];
}

-(void)changeKeyPath:(NSString*)keyPath ofObject:(id)obj toValue:(id)newValue{
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey]; // берем старое значение
    if (oldValue == [NSNull null]) { // проверка на пустое значение
        oldValue = nil;
    }
    
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    
    [undo setActionName:@"Edit"];
}

@end
