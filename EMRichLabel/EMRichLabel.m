//
//  EMRichLabel.m
//  richlabel
//
//  Created by Dima Avvakumov on 19.11.12.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabel.h"

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
    [_render setText: text];
    [_render removeAllStyles];
    [_render removeAllBounds];
    
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

@end
