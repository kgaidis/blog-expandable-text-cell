//
//  ExpandableLabel.m
//  SeeMoreExample
//
//  Created by Krisjanis Gaidis on 5/25/15.
//  Copyright (c) 2015 Krisjanis Gaidis. All rights reserved.
//

#import "ExpandableLabel.h"
#import <CoreText/CoreText.h>

static NSString *const kExpandableLabelText = @"More";

@implementation ExpandableLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    [self truncate];
}

#pragma mark - Read More
#pragma mark

- (void)truncate {
    
    self.lineBreakMode = NSLineBreakByClipping;

    if ([self shouldTruncate]) {
        
        // Truncate the original string to 'self.numberOfLines' and append a special suffix
        NSInteger numberOfCharactersThatFitLabel = [self numberOfCharactersThatFitLabel];

        NSString *specialSuffix = [NSString stringWithFormat:@" ...%@", kExpandableLabelText];
        NSString *truncatedOriginalString = [self.text substringToIndex:numberOfCharactersThatFitLabel-specialSuffix.length];
        NSString *truncatedNewString = [truncatedOriginalString stringByAppendingString:specialSuffix];

        NSMutableAttributedString *attributedTruncatedNewString = [[NSMutableAttributedString alloc] initWithString:truncatedNewString attributes:nil];
        
        // Re-apply all of the attributes of the original string
        [self.attributedText enumerateAttributesInRange:NSMakeRange(0, numberOfCharactersThatFitLabel) options:NSAttributedStringEnumerationReverse usingBlock:
         ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
             [attributedTruncatedNewString setAttributes:attributes range:range];
         }];

        // Apply special attributes to the 'kExpandableLabelText'
        NSRange range = NSMakeRange(truncatedOriginalString.length + specialSuffix.length-kExpandableLabelText.length, kExpandableLabelText.length);
        [attributedTruncatedNewString addAttribute:NSFontAttributeName value:self.font range:range];
        [attributedTruncatedNewString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        
        // Set the new string
        [self setAttributedText:attributedTruncatedNewString];
    }
}

- (BOOL)shouldTruncate {

    if (self.numberOfLines == 0) {
        return NO;
    }
    
    // Calculate the height of the text with no truncation
    CGSize sizeOfText = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil].size;
    CGFloat actualHeightOfText = sizeOfText.height;
    
    // Calculate the height of the text bound to 'self.numberOfLines'
    CGFloat desiredHeightOfText = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines].size.height;
    
    return desiredHeightOfText < actualHeightOfText;
}

- (NSInteger)numberOfCharactersThatFitLabel {
    
    // Create an 'CTFramesetterRef' from an attributed string
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(__bridge id)fontRef forKey:(id)kCTFontAttributeName];
    CFRelease(fontRef);
    NSAttributedString *attributedString  = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);

    // Get a suggested character count that would fit the attributed string
    CFRange characterFitRange;
    CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0,0), NULL, CGSizeMake(self.bounds.size.width, self.numberOfLines*self.font.lineHeight), &characterFitRange);
    CFRelease(frameSetterRef);
    return (NSInteger)characterFitRange.length;
}

@end