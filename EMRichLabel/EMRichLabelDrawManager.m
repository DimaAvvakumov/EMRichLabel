//
//  EMRichLabelDrawManager.m
//  richlabel
//
//  Created by Dima Avvakumov on 29.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabelDrawManager.h"

@interface EMRichLabelDrawManager ()

@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation EMRichLabelDrawManager

+ (EMRichLabelDrawManager *) defaultManager {
    
	static EMRichLabelDrawManager *instance = nil;
	if (instance == nil) {
        instance = [[EMRichLabelDrawManager alloc] init];
    }
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount: 1];
    }
    return self;
}

#pragma mark - Custom methods

- (void) drawRender:(EMRichLabelRender *)render withIdentifer:(NSString *)identifer completition:(void (^)(UIImage *))block {
    EMRichLabelDrawOperation *operation = [[EMRichLabelDrawOperation alloc] initWithRender: render
                                                                        identifer: identifer
                                                                         andBlock: block];
    [_queue addOperation: operation];
}

- (void) cancelByIdentifier: (NSString *) identifier {
    NSArray *operations = [_queue operations];
    for (int i = 0; i < [operations count]; i++) {
        EMRichLabelDrawOperation *operation = [operations objectAtIndex: i];
        
        if ([[operation identifier] isEqualToString: identifier]) {
            [operation cancel];
        }
    }
}
@end
