//
//  EMRichLabelDrawOperation.m
//  richlabel
//
//  Created by Dima Avvakumov on 29.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabelDrawOperation.h"

@interface EMRichLabelDrawOperation () {
    BOOL _isReady;
    BOOL _finished;
    BOOL _executing;
    BOOL _isCancelled;
}

@property (nonatomic, strong) EMRichLabelRender *render;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, copy) EMRichLabelDrawOperationCompetitionBlock block;

- (void) finish;

@end

@implementation EMRichLabelDrawOperation

- (id) initWithRender:(EMRichLabelRender *)render identifer:(NSString *)identifier andBlock:(EMRichLabelDrawOperationCompetitionBlock)block {
    self = [super init];
    if (self) {
        _isReady = YES;
        _finished = NO;
        _executing = NO;
        _isCancelled = NO;
        
        [self setRender: render];
        [self setIdentifier: identifier];
        [self setBlock: block];
    }
    return self;
}

#pragma mark - NSOperation methods

- (void) start {
    if (_isCancelled) {
        [self finish];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    UIImage *image = [_render textImage];
    if (image == nil) {
        [self finish];
        return;
    }
    
    if (_isCancelled) {
        [self finish];
        return;
    }
    
    if (_block) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _block(image);
        });
    }
    
    [self finish];
}

- (void) finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void) cancel {
    _isCancelled = YES;
}

- (BOOL) isConcurrent {
    return YES;
}

- (BOOL) isReady {
    return _isReady;
}

- (BOOL) isExecuting {
    return _executing;
}

- (BOOL) isFinished {
    return _finished;
}

@end
