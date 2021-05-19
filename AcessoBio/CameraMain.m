//
//  CameraMain.m
//  CaptureAcesso
//
//  Created by Daniel Zanelatto on 20/05/19.
//  Copyright © 2019 Matheus  domingos. All rights reserved.
//

#import "CameraMain.h"
#import "UIImageUtils.h"
#import <sys/utsname.h>

@interface CameraMain ()

@end

@implementation CameraMain

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    unauthorized_error_bio = @"Verifique sua url de conexão, apikey e token. Se persistir, entre em contato com a equipe da unico.";

}

- (void)viewDidDisappear:(BOOL)animated {
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = [AVCaptureVideoPreviewLayer new];
    self.session = [AVCaptureSession new];;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            
          //  NSLog(@"entrou landscpae");
            break;
            
        case UIDeviceOrientationLandscapeRight:
          //  NSLog(@"entrou landscpae");
            
            break;
        default:
            break;
    };
}

- (void) setupCamera:(BOOL) isSelfie {
    
    self.session = [[AVCaptureSession alloc] init];
    self.delegate = self;
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.renderLock = [[NSLock alloc] init];
    
    NSError *error = nil;
    
    if (isSelfie) {
        self.defaultCamera = AVCaptureDevicePositionFront;
    } else {
        self.defaultCamera = AVCaptureDevicePositionBack;
    }
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:self.defaultCamera];
    
    if ([videoDevice hasFlash] && [videoDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
        if ([videoDevice lockForConfiguration:&error]) {
            [videoDevice setFlashMode:AVCaptureFlashModeOff];
            [videoDevice unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
    
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (!videoDeviceInput) {
        NSLog(@"No Input");
    }
    
    if ([[videoDeviceInput device] supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    } else if ([[videoDeviceInput device] supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
        
    }
    
    if ([self.session canAddInput:videoDeviceInput]) {
        [self.session addInput:videoDeviceInput];
        self.videoDeviceInput = videoDeviceInput;
    }
    
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.session canAddOutput:stillImageOutput]) {
        [self.session addOutput:stillImageOutput];
        if (@available(iOS 11.0, *)) {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecTypeJPEG}];
        } else {
            // Fallback on earlier versions
        }
        self.stillImageOutput = stillImageOutput;
    }
    
    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    if ([self.session canAddOutput:self.dataOutput]) {
        self.dataOutput = self.dataOutput;
        [self.dataOutput setAlwaysDiscardsLateVideoFrames:YES];
        [self.dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        [self.dataOutput setSampleBufferDelegate:self.delegate queue:self.sessionQueue];
        
        [self.session addOutput:self.dataOutput];
    }
    
    self.btTakePic = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2) - 40, SCREEN_HEIGHT - 100, 80, 80)];
    [self.btTakePic setImage:[UIImage imageNamed:@"ic_takepicture"] forState:UIControlStateNormal];
    [self.btTakePic setAlpha:0.5];
    [self.btTakePic setEnabled:NO];
    [self.view addSubview:self.btTakePic];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    UIView *myView = self.view;
    self.previewLayer.frame = myView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    [self updateOrientation:[self getCurrentOrientation]];
    
    self.view.userInteractionEnabled = TRUE;
}


- (void) startCamera {
    [self.session startRunning];
}

- (void) stopCamera {
    [self.session stopRunning];
}

- (AVCaptureDevice *) deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (AVCaptureVideoOrientation) getCurrentOrientation {
    return [self getCurrentOrientation: [[UIApplication sharedApplication] statusBarOrientation]];
}

- (AVCaptureVideoOrientation) getCurrentOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    AVCaptureVideoOrientation orientation;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
        case UIInterfaceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
    }
    return orientation;
}

- (void) updateOrientation:(AVCaptureVideoOrientation)orientation {
    AVCaptureConnection *captureConnection;
    if (self.stillImageOutput != nil) {
        captureConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoOrientationSupported]) {
            [captureConnection setVideoOrientation:orientation];
        }
    }
    if (self.dataOutput != nil) {
        captureConnection = [self.dataOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoOrientationSupported]) {
            [captureConnection setVideoOrientation:orientation];
        }
    }
}

/***Deprecated

 - (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
     [self updateOrientation:[self getCurrentOrientation:toInterfaceOrientation]];
 }
 */


- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (UIImage *)converCIImageToUIImage : (CIImage *)cIImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:cIImage fromRect:[cIImage extent]];
    UIImage* image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

- (float)normalizeXPoint : (float)point faceWidth:(float)faceWidth {
    return (SCREEN_WIDTH - point) + (faceWidth/2);
}

- (float)normalizeYPoint : (float)point faceHeight:(float)faceHeight {
    
    if([self isSmallScreen]) {
        return SCREEN_HEIGHT - ((point/2));
    }else{
        return SCREEN_HEIGHT - ((faceHeight/2) + (point/2));
    }
}

- (CGPoint)scaledPoint:(CGPoint)point
                xScale:(CGFloat)xscale
                yScale:(CGFloat)yscale
                offset:(CGPoint)offset {
    CGPoint resultPoint = CGPointMake(point.x * xscale + offset.x, point.y * yscale + offset.y);
    return resultPoint;
}

- (void)addCircleAtPoint:(CGPoint)point
                  toView:(UIView *)view
               withColor:(UIColor *)color
              withRadius:(NSInteger)width {
    CGRect circleRect = CGRectMake(point.x - width / 2, point.y - width / 2, width, width);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *circleView = [[UIView alloc] initWithFrame:circleRect];
        circleView.layer.cornerRadius = width / 2;
        circleView.alpha = 0.7;
        circleView.backgroundColor = color;
        [view addSubview:circleView];
        
    });
}

- (void)addRectangle:(CGRect)rect
              toView:(UIView *)view
           withColor:(UIColor *)color {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *newView = [[UIView alloc] initWithFrame:rect];
        newView.layer.cornerRadius = 10;
        newView.alpha = 0.3;
        newView.backgroundColor = color;
        [view addSubview:newView];
        
    });
    
}

- (CGRect)scaledRect:(CGRect)rect
              xScale:(CGFloat)xscale
              yScale:(CGFloat)yscale
              offset:(CGPoint)offset {
    CGRect resultRect = CGRectMake(rect.origin.x * xscale,
                                   rect.origin.y * yscale,
                                   rect.size.width * xscale,
                                   rect.size.height * yscale);
    //resultRect = CGRectOffset(resultRect, offset.x, offset.y);
    return resultRect;
}

- (UIColor *)getColorPrimary {
    return [UIColor colorWithRed:57.0f/255.0f green:74.0f/255.0f blue:98.0f/255.0f  alpha:1.0f];
}

- (NSString*) deviceName
{
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    static NSDictionary* deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              @"iPhone11,2": @"iPhone XS",         //
                              @"iPhone11,4": @"iPhone XS Max",     //
                              @"iPhone11,6": @"iPhone XS Max",     // China
                              @"iPhone11,8": @"iPhone XR",         //
                              @"iPhone12,1": @"iPhone 11",         //
                              @"iPhone12,3": @"iPhone 11 Pro",     //
                              @"iPhone12,5": @"iPhone 11 Pro Max", //

                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }

    NSString* deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }

    return deviceName;
}

- (BOOL)isSmallScreen {
    NSString *deviceName = [self deviceName];
    if([deviceName isEqualToString:@"iPhone 6"] ||
       [deviceName isEqualToString:@"iPhone 6S"] ||
       [deviceName isEqualToString:@"iPhone SE"] ||
       [deviceName isEqualToString:@"iPhone 5"] ||
       [deviceName isEqualToString:@"iPhone 5s"] ||
       [deviceName isEqualToString:@"iPhone 5c"]) {
        return YES;
    }
    return NO;
}

@end
