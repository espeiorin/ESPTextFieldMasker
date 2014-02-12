//
//  ESPMaskedTextField.m
//  ESPMaskedTextField
//
//  Created by André Gustavo Espeiorin on 11/02/14.
//  Copyright (c) 2014 André Gustavo Espeiorin. All rights reserved.
//

#import "ESPTextFieldMasker.h"
#import "ESPFormatter.h"

@implementation ESPTextFieldMasker

#pragma mark - Initializer
- (instancetype) initWithFormatter:(ESPFormatter *)formatter
{
    self = [super init];
    if (self) {
        self.formatter = formatter;
    }
    return self;
}

- (BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string
{

    [self.formatter updateMaskForText:string];

    return YES;
}

@end