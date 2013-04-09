//
//  EMRichLabelStyle.h
//  richlabel
//
//  Created by Dima Avvakumov on 19.11.12.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CTStringAttributes.h"

typedef enum {
    EMRichLabelAlignmentLeft    = kCTLeftTextAlignment,
    EMRichLabelAlignmentCenter  = kCTCenterTextAlignment,
    EMRichLabelAlignmentRight   = kCTRightTextAlignment,
    EMRichLabelAlignmentJustify = kCTJustifiedTextAlignment
} EMRichLabelAlignment;

typedef enum {
    EMRichLabelUnderlineNone    = kCTUnderlineStyleNone,
    EMRichLabelUnderlineSingle  = kCTUnderlineStyleSingle,
    EMRichLabelUnderlineDouble  = kCTUnderlineStyleDouble,
    EMRichLabelUnderlineThick   = kCTUnderlineStyleThick
} EMRichLabelUnderlineStyle;

@interface EMRichLabelStyle : NSObject <NSCopying>

@property (assign, nonatomic) NSUInteger rangeStart;
@property (assign, nonatomic) NSUInteger rangeLength;
@property (strong, nonatomic) NSString *fontName;
@property (assign, nonatomic) float fontSize;
@property (assign, nonatomic) float lineHeight;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) float indent;

@property (assign, nonatomic) EMRichLabelAlignment textAlignment;

@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) float shadowBlur;
@property (strong, nonatomic) UIColor *shadowColor;

@property (assign, nonatomic) EMRichLabelUnderlineStyle underlineStyle;
@property (strong, nonatomic) UIColor *underlineColor;

@end
