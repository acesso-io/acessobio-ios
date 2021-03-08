//
//  CameraBio.h
//  CaptureAcesso
//
//  Created by Daniel Zanelatto on 13/05/19.
//  Copyright © 2019 Matheus  domingos. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LivenessXResult.h"
#import "CameraFaceResult.h"
#import "CameraDocumentResult.h"
#import "OCRResult.h"
#import "FacematchResult.h"
#import "CreateProcess.h"
#import "CreateProcess.h"

@class LivenessXView;
@class CameraFaceView;
@class DocumentInsertView;

typedef NS_ENUM(NSInteger, DocumentType) {
    DocumentNone,
    DocumentCNH,
    DocumentRG,
    DocumentRGFrente,
    DocumentRGVerso
};

typedef NS_ENUM(NSInteger, LanguageOrigin) {
    Native,
    Flutter,
    ReactNative
};



@protocol AcessoBioDelegate <NSObject>

@optional
- (BOOL)cameraBioShouldAutoCapture;
- (BOOL)cameraBioShouldCountdow;

- (void)userClosedCameraManually;

- (void)onSuccesCameraDocument: (CameraDocumentResult *)result;
- (void)onErrorCameraDocument: (NSString *)error;

- (void)onSuccessOCR: (OCRResult *)result;
- (void)onErrorOCR: (NSString *)error;

- (void)onSuccessFacematch: (FacematchResult *)result;
- (void)onErrorFacematch: (NSString *)error;

- (void)onSuccessFacesCompare:(BOOL)status;
- (void)onErrorFacesCompare:(NSString *)error;

- (void)onSuccesLivenessX: (LivenessXResult *)result;
- (void)onErrorLivenessX: (NSString *)error;

- (void)onSuccesCameraFace: (CameraFaceResult *)result;
- (void)onErrorCameraFace: (NSString *)error;

@required
- (void)onErrorAcessoBioManager: (NSString *)error;


@end

@interface AcessoBioManager : NSObject  <AcessoBioDelegate>{
    UIViewController *viewController;
    
    LivenessXView *lView;
    CameraFaceView *cView;
    DocumentInsertView *dView;
    
    LanguageOrigin language;
    NSString *versionRelease;
    
    NSString *url;
    NSString *apikey;
    NSString *token;
    
    BOOL isAutoCapture;
    BOOL isSmartCamera;
    
    BOOL isFacematchProcess;
    
    DocumentType documentTypeFacematch;
    NSString * base64Facematch;
    
    UIColor *colorSilhoutteNeutral;
    UIColor *colorSilhoutteSuccess;
    UIColor *colorSilhoutteError;
    UIColor *colorBackground;
    UIColor *colorBackgroundBoxStatus;
    UIColor *colorTextBoxStatus;
    UIColor *colorBackgroundPopupError;
    UIColor *colorTextPopupError;
    UIColor *colorBackgroundButtonPopupError;
    UIColor *colorTitleButtonPopupError;
    UIImage *imageIconPopupError;
    
}

@property (nonatomic, weak) id <AcessoBioDelegate> delegate;

@property (nonatomic, strong) CreateProcess *createProcess;

#pragma mark - Instance
- (id)initWithViewController:(id)view url:(NSString*)url apikey: (NSString*)apikey token: (NSString*)token;

#pragma mark - Language Origin

- (void)setLanguageOrigin: (LanguageOrigin)origin release: (NSString*)release;

#pragma mark - Custom

- (void)disableAutoCapture;
- (void)disableSmartCamera;

- (void)enableAutoCapture;
- (void)enableSmartCamera;

- (void)setColorSilhoutteNeutral: (id)color;
- (void)setColorSilhoutteSuccess: (id)color;
- (void)setColorSilhoutteError: (id)color;
- (void)setColorBackground: (id)color;
- (void)setColorBackgroundBoxStatus: (id)color;
- (void)setColorTextBoxStatus: (id)color;
- (void)setColorBackgroundPopupError: (id)color;
- (void)setColorTextPopupError: (id)color;
- (void)setColorBackgroundButtonPopupError : (id)color;
- (void)setColorTitleButtonPopupError : (id)color;
- (void)setImageIconPopupError: (id)image;

#pragma mark - Camera

- (void)openLivenessX;
- (void)openLivenessXWithCreateProcess: (NSString *)code name:(NSString *) name;
- (void)openLivenessXWithCreateProcess: (NSString *)code name:(NSString *) name gender: (NSString *)gender birthdate: (NSString *)birthdate email: (NSString *)email phone : (NSString *)phone;

- (void)openCameraFace;
- (void)openCameraFaceWithCreateProcess: (NSString *)code name:(NSString *) name;
- (void)openCameraFaceWithCreateProcess: (NSString *)code name:(NSString *) name gender: (NSString *)gender birthdate: (NSString *)birthdate email: (NSString *)email phone : (NSString *)phone;

- (void)openCameraDocuments : (DocumentType) documentType;
- (void)openCameraDocumentOCR : (DocumentType) documentType;
- (void)onErrorCameraDocument: (NSString *)error;
- (void)openCameraDocumentFacematch : (DocumentType) documentType;

- (void)facesCompare: (NSString *)cpf;

#pragma mark - Callbacks
- (void)onSuccesLivenessX: (LivenessXResult *)base64;
-(void)onErrorLivenessX: (NSString *)error;
- (void)onSuccesCameraFace: (CameraFaceResult *)result;
- (void)onErrorCameraFace: (NSString *)error;



@end

