//
//  ErrorBio.m
//  AcessoBio
//
//  Created by Matheus Domingos on 14/05/21.
//  Copyright © 2021 Matheus Domingos Acesso. All rights reserved.
//

#import "ErrorBio.h"

@implementation ErrorBio


- (id)initCode:(NSInteger)code method:(NSString *)method description:(NSString *)description
{
    
    self = [super init];
    if(self) {
        self.Code = code;
        self.Method = method;
        self.Description = description;
    }
    
    return self;
    
}

@end
