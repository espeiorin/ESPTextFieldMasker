//
//  ESPMaskedTextField.h
//  ESPMaskedTextField
//
//  Created by André Gustavo Espeiorin on 11/02/14.
//  Copyright (c) 2014 André Gustavo Espeiorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESPFormatter;

@interface ESPTextFieldMasker : NSObject <UITextFieldDelegate>

@property (strong, nonatomic) ESPFormatter *formatter;

- (instancetype) initWithFormatter:(ESPFormatter *)formatter;

@end