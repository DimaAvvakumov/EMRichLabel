//
//  EMRichLabelDrawManager.h
//  richlabel
//
//  Created by Dima Avvakumov on 29.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMRichLabelRender.h"
#import "EMRichLabelDrawOperation.h"

@interface EMRichLabelDrawManager : NSObject

+ (EMRichLabelDrawManager *) defaultManager;

- (void) drawRender: (EMRichLabelRender *) render withIdentifer: (NSString *) identifer completition: (void (^)(UIImage *image)) block;
- (void) cancelByIdentifier: (NSString *) identifier;

@end
