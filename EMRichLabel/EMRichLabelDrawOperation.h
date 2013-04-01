//
//  EMRichLabelDrawOperation.h
//  richlabel
//
//  Created by Dima Avvakumov on 29.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMRichLabelRender.h"

typedef void (^EMRichLabelDrawOperationCompetitionBlock)(UIImage *);

@interface EMRichLabelDrawOperation : NSOperation

- (id) initWithRender: (EMRichLabelRender *) render identifer: (NSString *) identifier andBlock: (EMRichLabelDrawOperationCompetitionBlock) block;

- (NSString *) identifier;

@end
