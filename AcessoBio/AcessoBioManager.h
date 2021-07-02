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
#import "ErrorBio.h"

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

- (void)onSuccesCameraDocument: (CameraDocumentResult *)result;
- (void)onErrorCameraDocument: (ErrorBio *)error;

- (void)onSuccessOCR: (OCRResult *)result;
- (void)onErrorOCR: (ErrorBio *)error;

- (void)onSuccessFacematch: (FacematchResult *)result;
- (void)onErrorFacematch: (ErrorBio *)error;

- (void)onSuccessFacesCompare:(BOOL)status;
- (void)onErrorFacesCompare:(ErrorBio *)error;

/** Deprecated
 - (void)onSuccesLivenessX: (LivenessXResult *)result;
 - (void)onErrorLivenessX: (NSString *)error;
 */

- (void)onSuccesCameraFace: (CameraFaceResult *)result;
- (void)onErrorCameraFace: (ErrorBio *)error;

@required
- (void)onErrorAcessoBioManager: (ErrorBio *)error;
- (void)userClosedCameraManually;
- (void)systemClosedCameraTimeoutSession;
- (void)systemClosedCameraTimeoutFaceInference;

@end

@interface AcessoBioManager : NSObject  <AcessoBioDelegate>{
    UIViewController *viewController;
    
    LivenessXView *lView;
    CameraFaceView *cView;
    DocumentInsertView *dView;
    
    NSString *versionRelease;
    
    NSString *url;
    NSString *apikey;
    NSString *token;
    
    BOOL isFacematchProcess;
    
    DocumentType documentTypeFacematch;
    NSString * base64Facematch;
    
    UIImage *imageIconPopupError;
    
    double defaultTimeoutSession;
    double defaultTimeoutToFaceInference;
    double minimumTimeoutToFaceInference;

    BOOL hasImplementationError;
    
}

@property (nonatomic, weak) id <AcessoBioDelegate> delegate;

@property (nonatomic, strong) CreateProcess *createProcess;

#pragma mark - Instance
- (id)initWithViewController:(id)view url:(NSString*)url apikey: (NSString*)apikey token: (NSString*)token;

#pragma mark - Language Origin

- (void)setLanguageOrigin: (LanguageOrigin)origin release: (NSString*)release;
@property (readonly) LanguageOrigin language;

#pragma mark - Custom

- (void)disableAutoCapture;
- (void)disableSmartCamera;
@property (readonly) BOOL isAutoCapture;

- (void)enableAutoCapture;
- (void)enableSmartCamera;
@property (readonly) BOOL isSmartCamera;

@property (nonatomic, strong) UIColor *colorSilhoutteNeutral;
@property (nonatomic, strong) UIColor *colorSilhoutteSuccess;
@property (nonatomic, strong) UIColor *colorSilhoutteError;
@property (nonatomic, strong) UIColor *colorBackground;
@property (nonatomic, strong) UIColor *colorBackgroundBoxStatus;
@property (nonatomic, strong) UIColor *colorTextBoxStatus;
@property (nonatomic, strong) UIColor *colorBackgroundPopupError;
@property (nonatomic, strong) UIColor *colorTextPopupError;
@property (nonatomic, strong) UIColor *colorBackgroundButtonPopupError;
@property (nonatomic, strong) UIColor *colorTitleButtonPopupError;

- (void)setImageIconPopupError: (id)image;

#pragma mark - Timeouts

- (void)setTimeoutToFaceInference : (double)seconds;
@property (readonly) double secondsTimeoutSession;
- (void)setTimeoutSession: (double)seconds;
@property (readonly) double secondsTimeoutToFaceInference;

#pragma mark - Camera

/** Deprecated
//- (void)openLivenessX;
//- (void)openLivenessXWithCreateProcess: (NSString *)code name:(NSString *) name;
//- (void)openLivenessXWithCreateProcess: (NSString *)code name:(NSString *) name gender: (NSString *)gender birthdate: (NSString *)birthdate email: (NSString *)email phone : (NSString *)phone;
*/

- (void)openCameraFace;
- (void)openCameraFaceWithCreateProcess: (NSString *)code name:(NSString *) name __deprecated_msg("Este método está depreciado e será removido em breve. Para realizar criação de processo use via server-to-server.");
- (void)openCameraFaceWithCreateProcess: (NSString *)code name:(NSString *) name gender: (NSString *)gender birthdate: (NSString *)birthdate email: (NSString *)email phone : (NSString *)phone __deprecated_msg("Este método está depreciado e será removido em breve. Para realizar criação de processo use via server-to-server.");

- (void)openCameraDocuments : (DocumentType) documentType;
- (void)openCameraDocumentOCR : (DocumentType) documentType __deprecated_msg("Este método está depreciado e será removido em breve. Para realizar o OCR use via server-to-server.");
- (void)onErrorCameraDocument: (ErrorBio *)error;
- (void)openCameraDocumentFacematch : (DocumentType) documentType;

- (void)facesCompare: (NSString *)cpf __deprecated_msg("Este método está depreciado e será removido em breve. Para realizar a comparação de face use via server-to-server.");

#pragma mark - Callbacks
/***Deprecated
 - (void)onSuccesLivenessX: (LivenessXResult *)base64;
 -(void)onErrorLivenessX: (NSString *)error;
 */
- (void)onSuccesCameraFace: (CameraFaceResult *)result;
- (void)onErrorCameraFace: (ErrorBio *)error;



@end

