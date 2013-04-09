//
//  EMRichLabelRender.m
//  richlabel
//
//  Created by Dima Avvakumov on 29.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabelRender.h"

@interface EMRichLabelRender() {
    CFMutableAttributedStringRef _attributedString;
    CTFrameRef _textFrame;
    
    float _fontAscender;
    
    BOOL _needCreate;
    BOOL _needUpdate;
}

@property (strong, nonatomic) NSMutableArray *styleCollection;
@property (assign, nonatomic) float maxWidth;
@property (assign, nonatomic) float textScale;
@property (assign, nonatomic) float lineHeight;
@property (strong, nonatomic) NSString *sourceText;
@property (assign, nonatomic) EMRichLabelAlignment textAlignment;
@property (assign, nonatomic) float textIndent;
@property (strong, nonatomic) UIColor *sourceColor;
@property (strong, nonatomic) NSMutableArray *textBounds;
@property (strong, nonatomic) NSString *fontName;
@property (assign, nonatomic) float fontSize;
@property (strong, nonatomic) UIColor *shadowColor;
@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) float shadowCustomBlur;

@property (strong, nonatomic) UIImage *renderImage;

- (void) initSelf;
- (void) applyStyleParagfaf: (EMRichLabelStyle *) style;

- (CTFrameRef) textFrame;
- (CFMutableAttributedStringRef) attributedString;

@end

@implementation EMRichLabelRender

- (id) init {
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id) initWithWidth: (float) width {
    self = [super init];
    if (self) {
        [self initSelf];
        self.maxWidth = width;
    }
    return self;
}

- (void) initSelf {
    _attributedString = nil;
    _textFrame = nil;
    
    _styleCollection = nil;
    
    _sourceText = nil;
    _maxWidth = 200.0;
    _lineHeight = 0;
    self.sourceColor = [UIColor blackColor];
    _textBounds = nil;
    _textScale = 1.0;
    _textAlignment = (EMRichLabelAlignment) kCTTextAlignmentLeft;
    _textIndent = 0.0;
    
    _shadowCustomBlur = 1.0;
    
    self.fontName = @"Helvetica";
    self.fontSize = 12.0;
    
    _renderImage = nil;
}

- (void) dealloc {
    if (_attributedString) {
        CFRelease(_attributedString);
    }
    if (_textFrame) {
        CFRelease(_textFrame);
    }
}

- (void) setText: (NSString *) text {
    self.sourceText = text;
    
    _needCreate = YES;
}

- (void) setWidth: (float) width {
    _maxWidth = width;
    
    _needUpdate = YES;
}

- (void) setLineHeight:(float)lineHeight {
    _lineHeight = lineHeight;
    
    _needUpdate = YES;
}

- (void) setTextAlignment:(EMRichLabelAlignment)textAlignment {
    _textAlignment = textAlignment;
    
    _needCreate = YES;
}

- (void) setTextIndent:(float)textIndent {
    _textIndent = textIndent;
    
    _needCreate = YES;
}

- (void) setColor: (UIColor *) color {
    self.sourceColor = color;
    
    _needCreate = YES;
}

- (void) setFontWithName: (NSString *) fontName andSize: (float) fontSize {
    self.fontName = fontName;
    self.fontSize = fontSize;
    
    CTFontRef font = CTFontCreateWithName( (__bridge CFStringRef) _fontName, _fontSize * _textScale, NULL );
    _fontAscender = CTFontGetDescent(font);
    if (_fontAscender < 0) _fontAscender = - _fontAscender;
    _fontAscender = ceilf(_fontAscender);
    CFRelease(font);
    
    _needCreate = YES;
}

- (void) setScale: (float) scale {
    _textScale = scale;
    
    _needCreate = YES;
}

- (void) addBound: (CGRect) bound {
    if (_textBounds == nil) {
        self.textBounds = [NSMutableArray arrayWithCapacity: 1];
    }
    
    [_textBounds addObject: [NSValue valueWithCGRect: bound]];
    
    _needCreate = YES;
}

- (void) removeAllBounds {
    self.textBounds = nil;
    
    _needCreate = YES;
}

- (void) addStyle: (EMRichLabelStyle *) style {
    if (_styleCollection == nil) {
        self.styleCollection = [NSMutableArray arrayWithCapacity: 1];
    }
    
    [_styleCollection addObject: style];
    
    _needCreate = YES;
}

- (void) removeAllStyles {
    self.styleCollection = nil;
    
    _needCreate = YES;
}

- (void) setShadowColor: (UIColor *) color andOffset: (CGSize) offset {
    self.shadowColor = color;
    self.shadowOffset = offset;
    
    _needUpdate = YES;
}

- (void) setShadowBlur: (float) blur {
    self.shadowCustomBlur = blur;
    
    _needUpdate = YES;
}

- (void) drawInContext: (CGContextRef) context {
    UIImage *image = [self textImage];
    
    [image drawAtPoint: CGPointMake(0.0, 0.0)];
}

- (UIImage *) textImage {
    if (_renderImage && !_needUpdate && !_needCreate) {
        return _renderImage;
    }
    
    CTFrameRef textFrame = [self textFrame];
    
    NSArray *lines = (__bridge NSArray *) CTFrameGetLines(textFrame);
    NSUInteger countLines = [lines count];
    
    float adding = 0.0;
    if (_fontSize > _lineHeight) {
        adding = _fontSize - _lineHeight;
    }
    CGSize size = CGSizeMake(_maxWidth, _lineHeight * countLines + _fontAscender + adding);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    if (_shadowColor) {
        CGContextSetShadowWithColor(context, _shadowOffset, _shadowCustomBlur, _shadowColor.CGColor);
    }
    
    float x = 0.0;
    float maxHeight = countLines * _lineHeight;
    float y = maxHeight + _fontSize;
    
	CGContextTranslateCTM(context, x, y);
	CGContextScaleCTM(context, 1.0, -1.0);
    
    for (int i = 0; i < countLines; i++) {
        //float lineY = maxHeight - roundf((float) i * _lineHeight * textScale) - roundf(_fontAscender * textScale);
        float lineY = maxHeight - roundf((float) i * _lineHeight * _textScale);
        CGPoint lineOrigin;
        CTFrameGetLineOrigins(textFrame, CFRangeMake(i, 1), &lineOrigin);
        
        CGContextSetTextPosition(context, lineOrigin.x, lineY);
        
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex: i];
        
        CTLineDraw(line, context);
    }
    
    //	CTFrameDraw(textFrame, context);
    self.renderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _renderImage;
}

- (CGSize) size {
    UIImage *image = [self textImage];
    
    return image.size;
}

- (CTFrameRef) textFrame {
    if (_textFrame && !_needUpdate && !_needCreate) {
        return _textFrame;
    }
    if (_textFrame) {
        CFRelease(_textFrame);
    }
    
    CFAttributedStringRef attributedString = [self attributedString];
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedString);
    
    CGSize frameAct = CGSizeMake(_maxWidth * _textScale, 9000.0);
    
    // Initialize a rectangular path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectZero;
    bounds.size = frameAct;
    CGPathAddRect(path, NULL, bounds);
    
    if (_textBounds) {
        for (NSValue *boundValue in _textBounds) {
            CGRect boundFrame = [boundValue CGRectValue];
            boundFrame.origin.y = frameAct.height - boundFrame.origin.y - boundFrame.size.height;
            
            boundFrame.origin.x = roundf(boundFrame.origin.x * _textScale);
            boundFrame.origin.y = roundf(boundFrame.origin.y * _textScale);
            boundFrame.size.width   = roundf(boundFrame.size.width * _textScale);
            boundFrame.size.height  = roundf(boundFrame.size.height * _textScale);
            
            CGPathAddRect(path, NULL, boundFrame);
        }
    }
    
	_textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	CFRelease(framesetter);
	CFRelease(path);
    
    _needUpdate = NO;
    
    return _textFrame;
}

- (CFMutableAttributedStringRef) attributedString {
    if (_attributedString && !_needCreate) {
        return _attributedString;
    }
    
    if (_attributedString) {
        CFRelease(_attributedString);
    }
    
    if (_sourceText == nil) {
        self.sourceText = @"";
    }
    
    _attributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString(_attributedString, CFRangeMake(0, 0), (CFStringRef) _sourceText);
    
    EMRichLabelStyle *style = [[EMRichLabelStyle alloc] init];
    style.rangeStart = 0;
    style.rangeLength = CFAttributedStringGetLength(_attributedString);
    style.fontName = _fontName;
    style.fontSize = _fontSize;
    style.color = _sourceColor;
    style.indent = _textIndent;
    [self applyStyleParagfaf: style];
    
    if (_styleCollection) {
        for (EMRichLabelStyle *style in _styleCollection) {
            [self applyStyleParagfaf: style];
        }
    }
    
    _needCreate = NO;
    
    return _attributedString;
}

- (void) applyStyleParagfaf: (EMRichLabelStyle *) style {
    CFRange range = CFRangeMake(style.rangeStart, style.rangeLength);
    
    // apply font
    CTFontRef font = NULL;
    if (style.fontName || style.fontSize) {
        NSString *fontName = _fontName;
        if (style.fontName) {
            fontName = style.fontName;
        }
        float fontSize = _fontSize;
        if (style.fontSize > 0) {
            fontSize = style.fontSize;
        }
        font = CTFontCreateWithName( (__bridge CFStringRef) fontName, fontSize * _textScale, NULL );
        CFAttributedStringSetAttribute(_attributedString, range, kCTFontAttributeName, font);
    }
    
    // underlining
    SInt32 type = style.underlineStyle;
    if (type) {
        CFNumberRef underline = CFNumberCreate(NULL, kCFNumberSInt32Type, &type);
        CFAttributedStringSetAttribute(_attributedString, range, kCTUnderlineStyleAttributeName, underline);
        CFRelease(underline);
    }
    if (style.underlineColor) {
        CFAttributedStringSetAttribute(_attributedString, range, kCTUnderlineColorAttributeName, style.underlineColor.CGColor);
    }
    
    // apply color
    if (style.color) {
        CFAttributedStringSetAttribute(_attributedString, range, kCTForegroundColorAttributeName, style.color.CGColor );
    }
    
    // apply paragraf
    if (font == NULL) {
        font = CTFontCreateWithName( (__bridge CFStringRef) _fontName, _fontSize * _textScale, NULL );
    }
    float fontLeading = CTFontGetLeading(font);
    float newLineHeight = _lineHeight * _textScale - floorf(fontLeading + 0.5);
    float lineSpacing = 0.0;
    float indent = _textIndent;
    if (style.indent < CGFLOAT_MAX) {
        indent = style.indent;
    }
    indent = roundf(indent * _textScale);
    CTTextAlignment newAlignment = (CTTextAlignment) _textAlignment;
    CTParagraphStyleSetting theSettings[5] = {
        //        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &lineSpacing },
        //        { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &lineSpacing },
        //        { kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &multiple},
        { kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &indent},
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &newLineHeight},
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &newLineHeight},
        //        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing}
        { kCTParagraphStyleSpecifierAlignment, sizeof(newAlignment), &newAlignment},
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, 5);
    
    CFAttributedStringSetAttribute(_attributedString, range, kCTParagraphStyleAttributeName, paragraphStyle);
    CFRelease(paragraphStyle);
    //    if (font) {
    //        CFRelease(font);
    //    }
}

@end
