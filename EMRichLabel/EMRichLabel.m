//
//  EMRichLabel.m
//  richlabel
//
//  Created by Dima Avvakumov on 19.11.12.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabel.h"
#import "EMRichLabelSharedStyles.h"
#import "EMRichLabelRender.h"
#import "EMRichLabelDrawManager.h"

@interface EMRichLabel ()

@property (strong, nonatomic) EMRichLabelRender *render;
@property (strong, nonatomic) UIImage *preImage;

- (void) initSelf;

@end

@implementation EMRichLabel

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void) initSelf {
    self.render = [[EMRichLabelRender alloc] initWithWidth: self.frame.size.width];
    
    [self setBackgroundColor: [UIColor clearColor]];
    
    self.delayRender = NO;
    self.preImage = nil;
}

- (void) setLineHeight: (float) lineHeight {
    [_render setLineHeight: lineHeight];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setText: (NSString *) text {
    [_render removeAllStyles];
    [_render removeAllBounds];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(/?[a-z0-9_-]+)>" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Regular exp error: %@", error);
    }
    NSString *cleanText = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if (matches && [matches count]) {
        NSMutableArray *tags = [NSMutableArray arrayWithCapacity: [matches count]];
        NSMutableArray *poss = [NSMutableArray arrayWithCapacity: [matches count]];
        
        NSUInteger offset = 0;
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            NSRange firstHalfRange = [match rangeAtIndex:1];
            
            [tags addObject: [text substringWithRange: firstHalfRange]];
            [poss addObject: [NSNumber numberWithInt: (matchRange.location - offset)]];
            
            offset += matchRange.length;
        }
        
        for (int i = 0; i < [tags count]; i++) {
            NSString *tag = [tags objectAtIndex: i];
            NSUInteger start = [[poss objectAtIndex: i] integerValue];
            
            if (![tag hasPrefix: @"/"]) {
                NSUInteger index = [self positionOfString:[NSString stringWithFormat: @"/%@", tag] inArray:tags startIndex:i];
                if (index == NSNotFound) continue;
                
                NSUInteger end = [[poss objectAtIndex: index] integerValue];
                
                EMRichLabelStyle *style = [[EMRichLabelSharedStyles sharedInstance] styleByName: tag];
                if (style) {
                    style.rangeStart = start;
                    style.rangeLength = end - start;
                    
                    [_render addStyle: style];
                } else {
                    NSLog(@"Style named: %@ not found in style sheet", tag);
                }
            }
        }
    }
    
    [_render setText: cleanText];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setStyleByName: (NSString *) name {
    EMRichLabelStyle *style = [[EMRichLabelSharedStyles sharedInstance] styleByName: name];
    if (style == nil) {
        NSLog(@"Style named: %@ not found in style sheet", name);
        
        return;
    }
    
    // font
    if (style.fontName && style.fontSize) {
        [_render setFontWithName: style.fontName andSize: style.fontSize];
    }
    
    // line height
    if (style.lineHeight > 0) {
        [_render setLineHeight: style.lineHeight];
    }
    
    // color
    if (style.color) {
        [_render setColor: style.color];
    }
    
    // indent
    if (style.indent > 0) {
        [_render setTextIndent: style.indent];
    }
    
    // text alignment
    [_render setTextAlignment: style.textAlignment];
    
    // shadow
    [_render setShadowColor:style.shadowColor andOffset:style.shadowOffset];
    [_render setShadowBlur:style.shadowBlur];
    
    // underline
    // [_render setUnderlineStyle: style.underlineStyle andColor: style.underlineColor];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setColor: (UIColor *) color {
    [_render setColor: color];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setFontWithName:(NSString *)fontName andSize:(float)fontSize {
    [_render setFontWithName: fontName andSize: fontSize];
    [_render setLineHeight: fontSize];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setTextAlignment: (EMRichLabelAlignment) alignment {
    [_render setTextAlignment: alignment];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setTextIndent:(float)textIndent {
    [_render setTextIndent: textIndent];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setScale: (float) scale {
    [_render setScale: scale];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setShadowColor: (UIColor *) color andOffset: (CGSize) offset {
    [_render setShadowColor: color andOffset: offset];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) setShadowBlur: (float) blur {
    [_render setShadowBlur: blur];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) addBound: (CGRect) bound {
    [_render addBound: bound];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) removeAllBounds {
    [_render removeAllBounds];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) removeAllStyles {
    [_render removeAllStyles];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (void) addStyle:(EMRichLabelStyle *)style {
    [_render addStyle: style];
    
    self.preImage = nil;
    [self setNeedsDisplay];
}

- (CGSize) size {
    return [_render size];
}

- (UIImage *) textImage {
    return [_render textImage];
}

- (void) drawRect: (CGRect) rect {
    if (_delayRender) {
        if (_preImage) {
            
            [_preImage drawAtPoint: CGPointMake(0.0, 0.0)];
        } else {
            [_render setWidth: self.frame.size.width];
            [[EMRichLabelDrawManager defaultManager] drawRender: _render withIdentifer: nil completition:^(UIImage *image) {
                self.preImage = image;
                [self setNeedsDisplay];
                
                [_delegate richLabelDidFinishDraw: self];
            }];
        }
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [_render setWidth: self.frame.size.width];
        [_render drawInContext: context];
    }
}

#pragma mark - Shared styles

+ (void) setSharedStylesFile:(NSString *)filePath {
    [[EMRichLabelSharedStyles sharedInstance] setStylesFile: filePath];
}

#pragma mark - NSArray search

- (NSUInteger) positionOfString: (NSString *) str inArray: (NSArray *) arr startIndex: (NSUInteger) startIndex {
    for (int i = startIndex; i < [arr count]; i++) {
        NSString *inner = [arr objectAtIndex: i];
        if ([inner isKindOfClass: [NSString class]] && [inner isEqualToString: str]) {
            return i;
        }
    }
    
    return NSNotFound;
}


@end
