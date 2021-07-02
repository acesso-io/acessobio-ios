//
//  AcessoBioTests.m
//  AcessoBioTests
//
//  Created by Matheus Domingos on 30/06/21.
//  Copyright © 2021 Matheus Domingos Acesso. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../AcessoBio/AcessoBioManager.h"

@interface AcessoBioTests : XCTestCase

@property AcessoBioManager *acessoBioManager;

@end

@implementation AcessoBioTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.acessoBioManager = [[AcessoBioManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - SetUp

- (void)testConfigEnableCamera {
    NSNumber *expectedValueAtSmartCamera = [NSNumber numberWithBool:YES];
    [self.acessoBioManager enableSmartCamera];
    NSNumber *resultValurAtSmartCamera = [NSNumber numberWithBool:self.acessoBioManager.isSmartCamera];
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueAtSmartCamera, resultValurAtSmartCamera, "testing enable smart camera config");
}

- (void)testConfigDisableCamera {
    NSNumber *expectedValueAtSmartCamera = [NSNumber numberWithBool:NO];
    [self.acessoBioManager disableSmartCamera];
    NSNumber *resultValurAtSmartCamera = [NSNumber numberWithBool:self.acessoBioManager.isSmartCamera];
    XCTAssertEqualObjects(expectedValueAtSmartCamera, resultValurAtSmartCamera, "testing disable smart camera config");
}

- (void)testConfigAutoCapture {
    NSNumber *expectedValueAtAutoCapture = [NSNumber numberWithBool:YES];
    [self.acessoBioManager enableAutoCapture];
    NSNumber *resultValueAtAutoCapture = [NSNumber
       numberWithBool:self.acessoBioManager.isAutoCapture];
    XCTAssertEqualObjects(expectedValueAtAutoCapture, resultValueAtAutoCapture, "testing enable auto capture config");
}

- (void)testConfigDisableAutoCapture {
    NSNumber *expectedValueAtAutoCapture = [NSNumber numberWithBool:NO];
    [self.acessoBioManager disableAutoCapture];
    NSNumber *resultValueAtAutoCapture = [NSNumber
       numberWithBool:self.acessoBioManager.isAutoCapture];
    XCTAssertEqualObjects(expectedValueAtAutoCapture, resultValueAtAutoCapture, "testing disable auto capture config");    
}

- (void)testConfigTimeoutSession {
    NSNumber *expectedValueTimeoutSession = [NSNumber
                                             numberWithInt:40];
    [self.acessoBioManager setTimeoutSession:40];
    NSNumber *resultValueAtTimeoutSession = [NSNumber
                                             numberWithInt:self.acessoBioManager.secondsTimeoutSession];
    XCTAssertEqualObjects(expectedValueTimeoutSession, resultValueAtTimeoutSession, "testing timeout session config");
}

- (void)testTimeOutToFaceInference {
    NSNumber *expectedValueTimeoutToFaceInference = [NSNumber numberWithInt:15];
    [self.acessoBioManager setTimeoutToFaceInference:15];
    NSNumber *resultValueAtTimeToFaceInference = [NSNumber numberWithInt:self.acessoBioManager.secondsTimeoutToFaceInference];
    XCTAssertEqualObjects(expectedValueTimeoutToFaceInference, resultValueAtTimeToFaceInference, "testing timeout to face inference");
}

- (void)testLanguageOrigin {
    NSNumber *origin = [NSNumber numberWithInteger:Flutter];
   [self.acessoBioManager setLanguageOrigin:Flutter release:
    @"1.0"];
    NSNumber *resultValueLanguageOrigin =  [NSNumber numberWithInteger: self.acessoBioManager.language];
    XCTAssertEqualObjects(origin, resultValueLanguageOrigin, "testing language origin");
}

#pragma mark - Custom
/* This test covers hexa string color and the UIColor with RGB */
- (void)testCustomSilhoutteNeutral {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorSilhoutteNeutral:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorSilhoutteNeutral;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color solhoutte neutral");
}

- (void)testCustomSilhoutteSuccess {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorSilhoutteSuccess:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorSilhoutteSuccess;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color solhoutte sucess");
}

- (void)testCustomSilhoutteError {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorSilhoutteError:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorSilhoutteError;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color solhoutte error");
}

- (void)testCustomBackground {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorBackground:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorBackground;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color background");
}

- (void)testCustomBackgroundBoxStatus {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorBackgroundBoxStatus:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorBackgroundBoxStatus;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color background box status");
}

- (void)testCustomTextBoxStatus {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorTextBoxStatus:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorTextBoxStatus;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color text box status");
}

- (void)testCustomBackgroundPopupError {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorBackgroundPopupError:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorBackgroundPopupError;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color background PopUp Error");
}

- (void)testCustomTextPopupError {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorTextPopupError:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorTextPopupError;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color text pop up error");
}

- (void)testCustomBackgroundButtonPopupError {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorBackgroundButtonPopupError:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorBackgroundButtonPopupError;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color background button pop up error");
}

- (void)testCustomTitleButtonPopupError {
    UIColor *expectedValueStringColor = [UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0];
    [self.acessoBioManager setColorTitleButtonPopupError:[UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1.0]];
    UIColor *resultValueStringColor = self.acessoBioManager.colorTitleButtonPopupError;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color title button pop up error");
}









@end
