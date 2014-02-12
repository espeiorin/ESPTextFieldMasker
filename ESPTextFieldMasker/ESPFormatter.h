//
//  ESPFormatter.h
//  ESPTextFieldMasker
//
//  Created by André Gustavo Espeiorin on 12/02/14.
//  Copyright (c) 2014 André Gustavo Espeiorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPFormatter : NSFormatter

@property (nonatomic, strong) NSString *mask;
@property (nonatomic, strong) NSArray *masks;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSArray *ignoredChars;

- (instancetype) initWithMasks:(NSArray *)masks placeholder:(NSString *)placeholder;
- (instancetype) initWithMask:(NSString *)mask placeholder:(NSString *)placeholder;

- (NSString *) rawStringFromFormattedValue:(NSString *)formatted;
- (NSString *) formattedStringFromRawValue:(NSString *)raw
                       displaysPlaceholder:(BOOL)displaysPlaceholder;

- (void) updateMaskForText:(NSString *)text;

@end