//
//  EMRichLabelStyle.m
//  richlabel
//
//  Created by Dima Avvakumov on 19.11.12.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "EMRichLabelStyle.h"

@implementation EMRichLabelStyle

- (id) copyWithZone:(NSZone *)zone {
    EMRichLabelStyle *copy = [[EMRichLabelStyle alloc] init];
    
    if (copy) {
        copy.rangeStart = self.rangeStart;
        copy.rangeLength = self.rangeLength;
        
        copy.fontName   = self.fontName;
        copy.fontSize   = self.fontSize;
        copy.lineHeight = self.lineHeight;
        
        copy.color  = self.color;
        copy.indent = self.indent;
        
        copy.textAlignment = self.textAlignment;
        
        copy.shadowOffset = self.shadowOffset;
        copy.shadowBlur   = self.shadowBlur;
        copy.shadowColor  = self.shadowColor;
        
        copy.underlineStyle = self.underlineStyle;
        copy.underlineColor = self.underlineColor;
    }
    return copy;
}

- (NSString *) description {
    NSString *underlineStyle;
    switch (_underlineStyle) {
        case EMRichLabelUnderlineSingle: {
            underlineStyle = @"Single";
            break;
        }
        case EMRichLabelUnderlineDouble: {
            underlineStyle = @"Double";
            break;
        }
        case EMRichLabelUnderlineThick: {
            underlineStyle = @"Thick";
            break;
        }
        default:
            underlineStyle = @"None";
            break;
    }
    
    return [NSString stringWithFormat: @"<%@>:\nrange: {%d,%d}\nfontName: %@\nfontSize: %f\nlineHeight: %f\ncolor: %@\nunderlineStyle: %@\nunderlineColor: %@", [self class], _rangeStart, _rangeLength, _fontName, _fontSize, _lineHeight, _color, underlineStyle, _underlineColor];
}

@end
