//
//  EMRichLabelSharedStyles.h
//  RichLabel
//
//  Created by Dima Avvakumov on 09.04.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMRichLabelStyle.h"

@interface EMRichLabelSharedStyles : NSObject

+ (EMRichLabelSharedStyles *) sharedInstance;
- (void) setStylesFile: (NSString *) filePath;

- (EMRichLabelStyle *) styleByName: (NSString *) name;

@end
