//
//  EMRichLabelRender.h
//  richlabel
//
//  Created by Dima Avvakumov on 29.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "EMRichLabelStyle.h"

@interface EMRichLabelRender : NSObject

- (id) initWithWidth: (float) width;

- (void) setText: (NSString *) text;
- (void) setWidth: (float) width;
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

- (void) drawInContext: (CGContextRef) context;
- (UIImage *) textImage;
- (CGSize) size;

@end
