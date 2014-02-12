//
//  ESPTextFieldMaskerTests.m
//  ESPTextFieldMaskerTests
//
//  Created by André Gustavo Espeiorin on 11/02/14.
//  Copyright (c) 2014 André Gustavo Espeiorin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "ESPTextFieldMasker.h"
#import "ESPFormatter.h"

@interface ESPTextFieldMaskerTests : XCTestCase

@property (nonatomic, strong) UITextField *defaultTextField;

@end

@implementation ESPTextFieldMaskerTests

- (void) setUp
{
    [super setUp];
    self.defaultTextField = [[UITextField alloc] init];

}

- (void) tearDown
{
    [super tearDown];
}

#pragma mark - Format Tests
- (void) testFormatInit
{
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:@"__/__/__" placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    XCTAssertNotNil(formatter, @"Can't be nil at this point");
    XCTAssertNotNil(formatter.mask, @"Can't be nil at this point");
    XCTAssertNotNil(formatter.placeholder, @"Can't be nil at this point");
    XCTAssertNotNil(formatter.ignoredChars, @"Can't be nil at this point");
}

- (void) testFormatInitFail
{
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:nil placeholder:nil];
    XCTAssertNil(formatter, @"Must be nil at this point");
}

- (void) testFormattedText
{
    NSString *rawString = @"250485";
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:@"__/__/__" placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    NSString *formattedString = [formatter formattedStringFromRawValue:rawString
                                                   displaysPlaceholder:YES];
    XCTAssert([formattedString isEqualToString:@"25/04/85"], @"Date must be formatted");
}

- (void) testRawText
{
    NSString *formattedString = @"25/04/85";
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:@"__/__/__" placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    NSString *rawString = [formatter rawStringFromFormattedValue:formattedString];
    XCTAssert([rawString isEqualToString:@"250485"], @"Date must not contain nothing except numbers");
}

- (void) testPlaceHolderDisplay
{
    NSString *rawString = @"250485";
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:@"__/__/____" placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    NSString *formattedString = [formatter formattedStringFromRawValue:rawString
                                                   displaysPlaceholder:YES];
    XCTAssert([formattedString isEqualToString:@"25/04/85__"], @"Date must be formatted with placeholder at end");
}

- (void) testPlaceHolderHidden
{
    NSString *rawString = @"250485";
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:@"__/__/____" placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    NSString *formattedString = [formatter formattedStringFromRawValue:rawString
                                                   displaysPlaceholder:NO];
    XCTAssert([formattedString isEqualToString:@"25/04/85"], @"Date must be formatted with placeholder at end");
}

- (void) testFormattedTextWithMultipleMasks
{
    NSString *rawString = @"2504198";
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMasks:@[@"__/__/__", @"__/__/____"]
                                                     placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    [formatter updateMaskForText:rawString];
    NSString *formattedString = [formatter formattedStringFromRawValue:rawString
                                                   displaysPlaceholder:YES];
    XCTAssert([formattedString isEqualToString:@"25/04/198_"], @"Date must be formatted");
}

#pragma mark - Masker Tests
- (void) testInit
{
    ESPFormatter *formatter = [[ESPFormatter alloc] initWithMask:@"__/__/__" placeholder:@"_"];
    formatter.ignoredChars = @[@"/"];
    ESPTextFieldMasker *maskedTextField = [[ESPTextFieldMasker alloc] initWithFormatter:formatter];
    XCTAssertNotNil(maskedTextField.formatter, @"Formatter should not be null");

    ESPTextFieldMasker *nulledTextFieldMasker = [[ESPTextFieldMasker alloc] init];
    XCTAssertNil(nulledTextFieldMasker.formatter, @"Formatter shoul be null");
}

- (void) testCharacterChanging
{
    XCTAssertNil(nil, @"");
}

@end
