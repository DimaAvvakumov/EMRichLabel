//
//  EMRichLabel.h
//  richlabel
//
//  Created by Dima Avvakumov on 19.11.12.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "EMRichLabelStyle.h"
#import "EMRichLabelRender.h"
#import "EMRichLabelDrawManager.h"

@class EMRichLabel;
@protocol EMRichLabelDelegate <NSObject>

- (void) richLabelDidFinishDraw: (EMRichLabel *) label;

@end

@interface EMRichLabel : UIView

@property (assign, nonatomic) BOOL delayRender;
@property (weak, nonatomic) IBOutlet id<EMRichLabelDelegate> delegate;

- (void) setText: (NSString *) text;
- (void) setLineHeight:(float)lineHeight;
- (void) setTextAlignment:(EMRichLabelAlignment)textAlignment;
- (void) setTextIndent:(float)textIndent;
- (void) setColor: (UIColor *) color;
- (void) setFontWithName: (NSString *) fontName andSize: (float) fontSize;
- (void) setScale: (float) scale;
- (void) addBound: (CGRect) bound;
- (void) removeAllBounds;
- (void) addStyle: (EMRichLabelStyle *) style;
- (void) removeAllStyles;
- (void) setShadowColor: (UIColor *) color andOffset: (CGSize) offset;
- (void) setShadowBlur: (float) blur;

- (CGSize) size;
- (UIImage *) textImage;

@end
