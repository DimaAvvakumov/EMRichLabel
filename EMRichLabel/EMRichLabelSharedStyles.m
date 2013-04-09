//
//  EMRichLabelSharedStyles.m
//  RichLabel
//
//  Created by Dima Avvakumov on 09.04.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabelSharedStyles.h"

@interface EMRichLabelSharedStyles()

@property (strong, nonatomic) NSMutableDictionary *styles;

@end

@implementation EMRichLabelSharedStyles

+ (EMRichLabelSharedStyles *) sharedInstance {
    
	static EMRichLabelSharedStyles *instance = nil;
	if (instance == nil) {
        instance = [[EMRichLabelSharedStyles alloc] init];
    }
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
        self.styles = nil;
    }
    return self;
}

- (void) setStylesFile: (NSString *) filePath {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile: filePath];
    if (dictionary == nil) return;
    
    self.styles = [NSMutableDictionary dictionaryWithCapacity: [dictionary count]];
    
    for (NSString *className in dictionary) {
        NSDictionary *styleRaw = [dictionary objectForKey: className];
        
        EMRichLabelStyle *style = [self parseRichTextStyle: styleRaw];
        if (style) {
            [_styles setObject:style forKey:className];
        }
    }
}

- (EMRichLabelStyle *) styleByName: (NSString *) name {
    if (_styles == nil) return nil;
    
    return [[_styles objectForKey: name] copy];
}

- (EMRichLabelStyle *) parseRichTextStyle: (NSDictionary *) rawInfo {
    if (!rawInfo || ![rawInfo isKindOfClass: [NSDictionary class]]) {
        return nil;
    }
    
    EMRichLabelStyle *item = [[EMRichLabelStyle alloc] init];
    
    // range
//    NSRange range = [rawInfo rangeForKey: @"Range"];
//    item.rangeStart = range.location;
//    item.rangeLength = range.length;
    item.rangeStart = 0;
    item.rangeLength = 0;
    
    // color
    NSString *labelColorStr = [self stringForKey:@"Color" inDictionary:rawInfo];
    NSArray *labelColorRGB = [labelColorStr componentsSeparatedByString: @","];
    if ([labelColorRGB count] == 3) {
        float red   = [[labelColorRGB objectAtIndex: 0] floatValue] / 255.0;
        float green = [[labelColorRGB objectAtIndex: 1] floatValue] / 255.0;
        float blue  = [[labelColorRGB objectAtIndex: 2] floatValue] / 255.0;
        item.color = [UIColor colorWithRed: red green: green blue: blue alpha:1.0];
    } else if ([labelColorRGB count] == 4) {
        float red   = [[labelColorRGB objectAtIndex: 0] floatValue] / 255.0;
        float green = [[labelColorRGB objectAtIndex: 1] floatValue] / 255.0;
        float blue  = [[labelColorRGB objectAtIndex: 2] floatValue] / 255.0;
        float alpha = [[labelColorRGB objectAtIndex: 3] floatValue] / 255.0;
        item.color = [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    } else {
        item.color = nil;
    }
    
    // font
    item.fontName = [self stringForKeyOrNil:@"FontName" inDictionary:rawInfo];
    item.fontSize = [[self numberForKey: @"FontSize" inDictionary:rawInfo] floatValue];
    item.lineHeight = [[self numberForKey: @"LineHeight" inDictionary:rawInfo] floatValue];
    item.indent = [[self numberForKey: @"Indent" inDictionary:rawInfo] floatValue];
    
    // text alignment
    int textAlignment = [[self numberForKey: @"TextAlignment" inDictionary:rawInfo] integerValue];
    switch (textAlignment) {
        case 1: {
            item.textAlignment = EMRichLabelAlignmentCenter;
            break;
        }
        case 2: {
            item.textAlignment = EMRichLabelAlignmentRight;
            break;
        }
        case 3: {
            item.textAlignment = EMRichLabelAlignmentJustify;
            break;
        }
        default:
            item.textAlignment = EMRichLabelAlignmentLeft;
            break;
    }
    
    // shadow offset and blur
    item.shadowOffset = [self sizeForKey: @"ShadowOffset" inDictionary: rawInfo];
    item.shadowBlur = [[self numberForKey: @"ShadowBlur" inDictionary:rawInfo] floatValue];
    if (item.shadowBlur == 0) {
        item.shadowBlur = 1.0;
    }
    
    // shadow color
    NSString *labelShadowColorStr = [self stringForKey: @"ShadowColor" inDictionary: rawInfo];
    NSArray *labelShadowColorRGB = [labelShadowColorStr componentsSeparatedByString: @","];
    if ([labelShadowColorRGB count] == 3) {
        float red   = [[labelShadowColorRGB objectAtIndex: 0] floatValue]  / 255.0;
        float green = [[labelShadowColorRGB objectAtIndex: 1] floatValue]  / 255.0;
        float blue  = [[labelShadowColorRGB objectAtIndex: 2] floatValue] / 255.0;
        item.shadowColor = [UIColor colorWithRed: red green: green blue: blue alpha:1.0];
    } else if ([labelShadowColorRGB count] == 4) {
        float red   = [[labelShadowColorRGB objectAtIndex: 0] floatValue]  / 255.0;
        float green = [[labelShadowColorRGB objectAtIndex: 1] floatValue]  / 255.0;
        float blue  = [[labelShadowColorRGB objectAtIndex: 2] floatValue] / 255.0;
        float alpha = [[labelShadowColorRGB objectAtIndex: 3] floatValue] / 255.0;
        item.shadowColor = [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    } else {
        item.shadowColor = nil;
    }
    
    // text underlying
    int underlineStyle = [[self numberForKey: @"UnderlineStyle" inDictionary:rawInfo] integerValue];
    switch (underlineStyle) {
        case 1: {
            item.underlineStyle = EMRichLabelUnderlineSingle;
            break;
        }
        case 2: {
            item.underlineStyle = EMRichLabelUnderlineDouble;
            break;
        }
        case 3: {
            item.underlineStyle = EMRichLabelUnderlineThick;
            break;
        }
        default: {
            item.underlineStyle = EMRichLabelUnderlineNone;
            break;
        }
    }
    NSString *lineColorStr = [self stringForKey:@"UnderlineColor" inDictionary:rawInfo];
    NSArray *lineColorRGB = [lineColorStr componentsSeparatedByString: @","];
    if ([lineColorRGB count] == 3) {
        float red   = [[lineColorRGB objectAtIndex: 0] floatValue] / 255.0;
        float green = [[lineColorRGB objectAtIndex: 1] floatValue] / 255.0;
        float blue  = [[lineColorRGB objectAtIndex: 2] floatValue] / 255.0;
        item.underlineColor = [UIColor colorWithRed: red green: green blue: blue alpha:1.0];
    } else if ([lineColorRGB count] == 4) {
        float red   = [[lineColorRGB objectAtIndex: 0] floatValue] / 255.0;
        float green = [[lineColorRGB objectAtIndex: 1] floatValue] / 255.0;
        float blue  = [[lineColorRGB objectAtIndex: 2] floatValue] / 255.0;
        float alpha = [[lineColorRGB objectAtIndex: 3] floatValue] / 255.0;
        item.underlineColor = [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    } else {
        item.underlineColor = nil;
    }
    
    return item;
}

#pragma mark - Simple gatters

- (NSString *) stringForKey: (id) key inDictionary: (NSDictionary *) dict {
    NSString *string = [dict objectForKey: key];
    if (string == nil) {
        return @"";
    }
    if ([string isKindOfClass: [NSString class]]) {
        return string;
    }
    if ([string isKindOfClass: [NSNumber class]]) {
        NSNumber *number = (NSNumber *) string;
        return [number stringValue];
    }
    
    return @"";
}

- (NSString *) stringForKeyOrNil:(id)key inDictionary: (NSDictionary *) dict {
    NSString *string = [dict objectForKey: key];
    if (string == nil) {
        return nil;
    }
    if ([string isKindOfClass: [NSString class]]) {
        return string;
    }
    if ([string isKindOfClass: [NSNumber class]]) {
        NSNumber *number = (NSNumber *) string;
        return [number stringValue];
    }
    
    return nil;
}

- (NSNumber *) numberForKey: (id) key inDictionary: (NSDictionary *) dict {
    id number = [dict objectForKey: key];
    if (number != nil) {
        if ([number isKindOfClass: [NSNumber class]]) {
            return number;
        }
        if ([number isKindOfClass: [NSString class]]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            [f setLocale: locale];
            [f setNumberStyle: NSNumberFormatterDecimalStyle];
            NSNumber *fNumber = [f numberFromString: number];
            
            if (fNumber != nil) {
                return fNumber;
            }
        }
    }
    
    return [NSNumber numberWithInt: 0];
}

- (CGPoint) pointForKey: (id) key inDictionary: (NSDictionary *) dict {
    id obj = [dict objectForKey: key];
    if (obj && [obj isKindOfClass: [NSString class]]) {
        return CGPointFromString((NSString *) obj);
    }
    return CGPointZero;
}

- (CGSize) sizeForKey: (id) key inDictionary: (NSDictionary *) dict {
    id obj = [dict objectForKey: key];
    if (obj && [obj isKindOfClass: [NSString class]]) {
        return CGSizeFromString((NSString *) obj);
    }
    return CGSizeZero;
}


@end
