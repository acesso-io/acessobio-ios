//
//  DocumentInsertView.m
//  CaptureAcesso
//
//  Created by Daniel Zanelatto on 20/05/19.
//  Copyright © 2019 Matheus  domingos. All rights reserved.
//

#import "DocumentInsertView.h"
#import "AcessoBioManager.h"
#import "UIImageUtils.h"
#import "FacematchResult.h"

@interface DocumentInsertView ()

@end

@implementation DocumentInsertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupCamera:NO];
    [self startCamera];
    
    [self addMask];
    
}

- (void)addMask {
    
    float heightViewBottom = 0;
    float valueLessMask = 0;
    
    if(IS_IPHONE_5 || IS_IPHONE_6) {
        heightViewBottom = 110.0f;
        valueLessMask = 40.0f;
    }else{
        heightViewBottom = 150.0f;
        valueLessMask = 0.0f;
    }
    
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (heightViewBottom - valueLessMask) )];
    [iv setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:iv];
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - heightViewBottom, SCREEN_WIDTH, heightViewBottom)];
    [viewBottom setBackgroundColor:[self getColorPrimary]];
    [self.view addSubview:viewBottom];
    
    
    UILabel *lbStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - (heightViewBottom/2)) - 10, SCREEN_WIDTH, 40)];
    [lbStatus setTextColor:[UIColor whiteColor]];
    [lbStatus setTextAlignment:NSTextAlignmentCenter];
    [lbStatus setFont:[UIFont fontWithName:@"Avenir-Book" size:18.0]];
    
    
    [self.view addSubview:lbStatus];
    
    
    if(self.type == 4) {
        
        [iv setImage:[UIImage imageNamed:@"frame_cnh" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
        [lbStatus setText:@"Enquadre a CNH aberta"];
    }else if (self.type == 501) {
        [iv setImage:[UIImage imageNamed:@"frame_rg_frente" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
        [lbStatus setText:@"Enquadre o RG frente aberto"];
    }else if (self.type == 502){
        [iv setImage:[UIImage imageNamed:@"frame_rg_verso" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
        [lbStatus setText:@"Enquadre o RG verso aberto"];
    }else{
        [iv setHidden:YES];
        [lbStatus setText:@"Enquadre o documento"];
    }
    
    
    [self.btTakePic setEnabled:YES];
    [self.btTakePic setAlpha:1.0];
    [self.btTakePic setFrame:CGRectMake((SCREEN_WIDTH/2) - 35, SCREEN_HEIGHT - heightViewBottom - 35, 70, 70)];
    [self.btTakePic.layer setMasksToBounds:YES];
    [self.btTakePic.layer setCornerRadius:self.btTakePic.frame.size.height/2];
    [self.btTakePic addTarget:self action:@selector(invokeTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btTakePic];
    
    [self addCloseButton];
    
}


#pragma mark - Close
- (void)addCloseButton {
    
    btClose = [[UIButton alloc]initWithFrame:CGRectMake(7, 20, 70, 70)];
    [btClose setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [btClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btClose];
    
}

- (void)close {
    [self.acessoBioManager userClosedCameraManually];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) invokeTakePicture {
    
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef sampleBuffer, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            [self.renderLock lock];
            [self.renderLock unlock];
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
            UIImage *capturedImage = [[UIImage alloc] initWithData:imageData];
            
            if (self.defaultCamera == AVCaptureDevicePositionFront) {
                capturedImage = [UIImageUtils flipImage:[UIImageUtils imageRotatedByDegrees:capturedImage deg:-90]];
            } else {
                capturedImage = [UIImageUtils imageRotatedByDegrees:capturedImage deg:90];
            }
            
            NSString* base64;
            base64 = [UIImageUtils getBase64Image: capturedImage]; // Utilizar esse base64 para a validação no WebService
            
            [self actionAfterTakePicture:base64];
            
            [self stopCamera];
            
        }
    }];
    
}

- (void)actionAfterTakePicture : (NSString *)base64 {
    
    if(self.operationType == Facematch) {
        [self facematch:base64];
    }else if(self.operationType == OCR) {
        [self ocr:base64];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        CameraDocumentResult *cameraResult = [CameraDocumentResult new];
        cameraResult.base64 = base64;
        [self.acessoBioManager onSuccesCameraDocument:cameraResult];
    }
    
}

- (void)showHUB {
    
    if(vFlash == nil) {
        
        vFlash= [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [vFlash setBackgroundColor:[UIColor whiteColor]];
        [vFlash setAlpha:0.9];
        
        UIColor *colorBackground = [UIColor colorWithRed:57.0f/255.0f green:74.0f/255.0f blue:98.0f/255.0f  alpha:0.9f];
        
        if(self.colorBackground != nil) {
            colorBackground = self.colorBackground;
        }
        [vFlash setBackgroundColor:colorBackground];
        [self.view addSubview:vFlash];
        
        spinFlash = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        if (@available(iOS 13.0, *)) {
            [spinFlash setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleLarge];
        } else {
            // Fallback on earlier versions
            [spinFlash setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        
        UIColor *colorSpin  = [UIColor whiteColor];
        if(self.colorSilhoutte != nil) {
            colorSpin = self.colorSilhoutte;
        }
        [spinFlash setColor:colorSpin];
        spinFlash.center = self.view.center;
        [spinFlash startAnimating];
        [self.view addSubview:spinFlash];
        
    }
}

- (void)dismissHUB {
    [spinFlash stopAnimating];
    [spinFlash removeFromSuperview];
    [vFlash removeFromSuperview];
    vFlash = nil;
    spinFlash = nil;
}

#pragma mark - OCR

- (void)ocr : (NSString *)base64 {
    
    [self showHUB];
    
    NSDictionary *dict = @{
        @"type": [NSString stringWithFormat:@"%ld", (long)self.type],
        @"base64": base64
    };
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/services/v3/AcessoService.svc/documents/ocr", self.URL]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getRequestMain:url params:dict] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if (data.length > 0 && error == nil)
        {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:NULL];
            NSDictionary *result = response;
            
            OCRResult *ocrResult = [OCRResult new];
            ocrResult.BirthDate = [result valueForKey:@"BirthDate"];
            ocrResult.Category = [result valueForKey:@"Category"];
            ocrResult.Code = [result valueForKey:@"Code"];
            ocrResult.ExpeditionCity = [result valueForKey:@"ExpeditionCity"];
            ocrResult.ExpeditionDate = [result valueForKey:@"ExpeditionDate"];
            ocrResult.ExpirationDate = [result valueForKey:@"ExpirationDate"];
            ocrResult.FatherName = [result valueForKey:@"FatherName"];
            ocrResult.FirstLicenseDate = [result valueForKey:@"FirstLicenseDate"];
            ocrResult.MirrorNumber = [result valueForKey:@"MirrorNumber"];
            ocrResult.MotherName = [result valueForKey:@"MotherName"];
            ocrResult.Name = [result valueForKey:@"Name"];
            ocrResult.RegistrationNumber = [result valueForKey:@"RegistrationNumber"];
            ocrResult.Renach = [result valueForKey:@"Renach"];
            ocrResult.RG = [result valueForKey:@"RG"];
            ocrResult.SecurityCode = [result valueForKey:@"SecurityCode"];
            
            [self.acessoBioManager onSuccessOCR:ocrResult];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self dismissHUB];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
            
        }else {
            
            NSData *data = [error.description dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if([json isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *error = [json valueForKey:@"Error"];
                NSString *Description = [error valueForKey:@"Description"];
                NSInteger Code = [[error valueForKey:@"Code"] integerValue];
                
                [self.acessoBioManager onErrorOCR:[[ErrorBio alloc]initCode:Code method:@"ocr" description:Description]];
                
            }else{
                
                [self.acessoBioManager onErrorOCR:[[ErrorBio alloc]initCode:401 method:@"ocr" description:self->unauthorized_error_bio]];
                
            }
            
            [self exitError];
            
        }
        
    }] resume];
    
    
    
}

#pragma mark - FACEMATCH

- (void)facematch : (NSString *)base64Document {
    
    [self showHUB];
    
    NSString *strBaseFace = [NSString stringWithFormat:@"%@", self.base64SelfieToFaceMatch];
    
    NSDictionary *dict = @{
        @"Base64Documento": base64Document,
        @"Base64Selfie": strBaseFace,
    };
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/services/v3/AcessoService.svc/faces/match", self.URL]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getRequestMain:url params:dict] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if (data.length > 0 && error == nil)
        {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:NULL];
            NSDictionary *dictresponse = response;
            
            
            FacematchResult *facematchResult = [FacematchResult new];
            
            facematchResult.Base64Document = base64Document;
            facematchResult.Base64Selfie = self.base64SelfieToFaceMatch;
            facematchResult.Status = [[dictresponse valueForKey:@"Status"] boolValue];
            
            [self.acessoBioManager onSuccessFacematch:facematchResult];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self dismissHUB];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
            
        }else {
            
            NSData *data = [error.description dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if([json isKindOfClass:[NSDictionary class]]) {
                NSDictionary *error = [json valueForKey:@"Error"];
                NSString *Description = [error valueForKey:@"Description"];
                NSInteger  Code = [[error valueForKey:@"Code"] integerValue];
            
                [self.acessoBioManager onErrorFacematch:[[ErrorBio alloc]initCode:Code method:@"facematch" description:Description]];
                
            }else{
                
                [self.acessoBioManager onErrorFacematch:[[ErrorBio alloc]initCode:401 method:@"facematch" description:self->unauthorized_error_bio]];
            }
            
            [self exitError];
            
        }
        
    }
      
      ] resume];
    
    
}

- (NSMutableURLRequest *)getRequestMain: (NSURL *)url params:(NSDictionary *)params {
    NSError *error;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.APIKEY forHTTPHeaderField:@"APIKEY"];
    [request addValue:self.TOKEN forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error]];
    return request;
}

- (void)exitError {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}


- (NSString *)strErrorFormatted: (NSString *)method description: (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", method, description];
}



@end
