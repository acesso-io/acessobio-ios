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


/* This test covers hexa string color and the UIColor with RGB */
- (void)testCustomSilhoutteNeutral {

    UIColor *expectedValueStringColor = [UIColor colorNamed:@"#6959CD"];
    [self.acessoBioManager setColorSilhoutteSuccess:nil];
    UIColor *resultValueStringColor = self.acessoBioManager.colorSilhoutteNeutral;
    //XCTAssertTrue([expectedValueAtSmartCamera isEqualToNumber:resultValurAtSmartCamera]);
    XCTAssertEqualObjects(expectedValueStringColor, resultValueStringColor, "testing custom color solhoutte neutral");
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
