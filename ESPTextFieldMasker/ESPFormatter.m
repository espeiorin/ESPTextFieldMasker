//
//  ESPFormatter.m
//  ESPTextFieldMasker
//
//  Created by André Gustavo Espeiorin on 12/02/14.
//  Copyright (c) 2014 André Gustavo Espeiorin. All rights reserved.
//

#import "ESPFormatter.h"

@implementation ESPFormatter

@synthesize ignoredChars = _ignoredChars;

#pragma mark - Instance  Methods
- (instancetype) initWithMasks:(NSArray *)masks placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        if (masks == nil || masks.count == 0) {
            return nil;
        }
        self.masks = masks;
        self.mask = self.masks[0];
        self.placeholder = placeholder;
    }
    return self;
}

- (instancetype) initWithMask:(NSString *)mask placeholder:(NSString *)placeholder
{
    if (mask == nil) {
        return nil;
    }
    self = [self initWithMasks:@[mask] placeholder:placeholder];
    if (self) {

    }
    return self;
}

- (void) updateMaskForText:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:self.placeholder withString:@""];
    for (NSString *mask in self.masks) {
        NSString *tempMask = mask;
        for (NSString *ignored in self.ignoredChars) {
            tempMask = [tempMask stringByReplacingOccurrencesOfString:ignored withString:@""];
        }
        if (tempMask.length >= text.length) {
            self.mask = mask;
            break;
        }
    }
}

- (NSString *) rawStringFromFormattedValue:(NSString *)formatted
{
    NSString *rawString = formatted;
    NSArray *ignoredChars = [@[self.placeholder] arrayByAddingObjectsFromArray:self.ignoredChars];
    NSUInteger ignoredCount = ignoredChars.count;
    for (NSUInteger i = 0; i < ignoredCount; i++) {
        rawString = [rawString stringByReplacingOccurrencesOfString:ignoredChars[i]
                                                         withString:@""];
    }
    return rawString;
}

- (NSString *) formattedStringFromRawValue:(NSString *)raw
                       displaysPlaceholder:(BOOL)displaysPlaceholder
{
    if (raw.length == 0) {
        return @"";
    }

    NSUInteger maskLength = self.mask.length;
    unichar *formattedChars = calloc(maskLength, sizeof(unichar));
    NSUInteger jumpedOverChars = 0;

    for (NSUInteger i = 0; i < maskLength; i++) {
        @autoreleasepool {
            @try {
                unichar maskChar = [self.mask characterAtIndex:i];
                unichar rawChar = [raw characterAtIndex:i - jumpedOverChars];
                if (maskChar == [self.placeholder characterAtIndex:0] &&
                    isnumber(rawChar)) {
                    formattedChars[i] = rawChar;
                } else {
                    jumpedOverChars++;
                    formattedChars[i] = maskChar;
                }
            }
            @catch (NSException *exception) {
                formattedChars[i] = [self.mask characterAtIndex:i];
            }
        }
    }

    NSString *formattedString = [NSString stringWithCharacters:formattedChars length:self.mask.length];

    if (!displaysPlaceholder) {
        NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSRange exclusionRange = [formattedString rangeOfCharacterFromSet:numberSet
                                                                  options:NSBackwardsSearch];

        if (exclusionRange.location != NSNotFound) {
            exclusionRange.location++;
            exclusionRange.length = formattedString.length - exclusionRange.location;
            formattedString = [formattedString stringByReplacingCharactersInRange:exclusionRange
                                                                       withString:@""];
        }
    }

    return formattedString;
}

#pragma mark - Custom Getters
- (NSString *) placeholder
{
    if (_placeholder == nil) {
        _placeholder = @"_";
    }
    return _placeholder;
}

- (NSString *) mask
{
    if (_mask == nil) {
        _mask = @"";
    }
    return _mask;
}

- (NSArray *) ignoredChars
{
    if (_ignoredChars == nil) {
        _ignoredChars = @[];
    }
    return _ignoredChars;
}

#pragma mark - Custom Setters
- (void) setMasks:(NSArray *)masks
{
    _masks = [masks sortedArrayUsingComparator:^NSComparisonResult(NSString *mask1, NSString *mask2) {
        for (NSString *ignored in self.ignoredChars) {
            mask1 = [mask1 stringByReplacingOccurrencesOfString:ignored withString:@""];
            mask2 = [mask2 stringByReplacingOccurrencesOfString:ignored withString:@""];
        }
        NSNumber *mask1Length = @(mask1.length);
        NSNumber *mask2Length = @(mask2.length);
        return [mask1Length compare:mask2Length];
    }];
}

@end