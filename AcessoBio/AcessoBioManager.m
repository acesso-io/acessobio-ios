//
//  CameraBio.m
//  CaptureAcesso
//
//  Created by Daniel Zanelatto on 13/05/19.
//  Copyright © 2019 Matheus  domingos. All rights reserved.
//
#import "AcessoBioManager.h"
#import "LivenessXView.h"
#import "CameraFaceView.h"
#import "DocumentInsertView.h"
#import "UIColorExtensions.h"

@implementation AcessoBioManager

- (id)initWithViewController:(id)view url:(NSString *)pUrl apikey:(NSString *)pApikey token:(NSString *)pToken
{
    
    self = [super init];
    if(self) {
        viewController = view;
        self.delegate = view;
        url = pUrl;
        apikey = pApikey;
        token = pToken;
        isAutoCapture = YES;
        isSmartCamera = YES;
        [self setDefaults];

    }
    
    return self;
    
}

#pragma mark - Defaults

- (void)setDefaults {
    hasImplementationError = NO;
    defaultTimeoutProcess = 40;
    defaultTimeoutToFaceInference = 15;
    minimumTimeoutToFaceInference = 5;
    [self setDefaultOrigin];
    [self setDefaultVersionRelease];
    [self setDefaultTimeoutProcess];
    [self setDefaultTimeoutFaceInference];
}

#pragma mark - Origin and Version

- (void)setDefaultOrigin {
    language = Native;
}

- (void)setDefaultVersionRelease {
    versionRelease = @"1.2.1.1";
}

#pragma mark - Timeout

- (void)setTimeoutToFaceInference : (double)seconds{
    if(seconds <= minimumTimeoutToFaceInference) {
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setTimeoutToFaceInference" description:@"É necessário insirir um valor maior que 5 segundos no método: setTimeoutToFaceInference."]];
        return;
    }
    secondsTimeoutToFaceInference = seconds;
}

- (void)setTimeoutProcess: (double)seconds{
    if(seconds <= defaultTimeoutProcess) {
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setTimeoutProcess" description:@"É necessário insirir um valor maior que 40 segundos no método: setTimeoutProcess."]];
        return;
    }
    secondsTimeoutProcess = seconds;
}

- (void)setDefaultTimeoutProcess {
    secondsTimeoutProcess = defaultTimeoutProcess;
}

- (void)setDefaultTimeoutFaceInference {
    secondsTimeoutToFaceInference = defaultTimeoutToFaceInference;
}

- (void)setLanguageOrigin: (LanguageOrigin)origin release: (NSString*)release{
    language = origin;
    versionRelease = release;
}

#pragma mark - Custom

- (void)disableAutoCapture {
    isAutoCapture = NO;
}

- (void)disableSmartCamera {
    isSmartCamera = NO;
}

- (void)enableAutoCapture {
    isAutoCapture = YES;
}

- (void)enableSmartCamera {
    isSmartCamera = YES;
}

- (void)setColorSilhoutteNeutral: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorSilhoutteNeutral = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorSilhoutteNeutral = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
}

- (void)setColorSilhoutteSuccess: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorSilhoutteSuccess = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorSilhoutteSuccess = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];    }
    
}

- (void)setColorSilhoutteError: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorSilhoutteError = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorSilhoutteError = [UIColor colorWithHexString:color];
        }else{
            
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        
    }
    
}

- (void)setColorBackground: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorBackground = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorBackground = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        
    }
    
}

- (void)setColorBackgroundBoxStatus: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorBackgroundBoxStatus = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorBackgroundBoxStatus = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
}

- (void)setColorTextBoxStatus: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorTextBoxStatus = color;
    }else if([color isKindOfClass:[NSString class]]) {
        colorTextBoxStatus = [UIColor colorWithHexString:color];
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
}

- (void)setColorBackgroundPopupError: (id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorBackgroundPopupError = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorBackgroundPopupError = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
}

- (void)setColorTextPopupError: (id)color {
    colorTextPopupError = color;
    
    if([color isKindOfClass:[UIColor class]]) {
        colorTextPopupError = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorTextPopupError = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
}

- (void)setColorBackgroundButtonPopupError:(id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorBackgroundButtonPopupError = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorBackgroundButtonPopupError = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
}

- (void)setColorTitleButtonPopupError:(id)color {
    
    if([color isKindOfClass:[UIColor class]]) {
        colorTitleButtonPopupError = color;
    }else if([color isKindOfClass:[NSString class]]) {
        if([self verifyColorString:color]) {
            colorTitleButtonPopupError = [UIColor colorWithHexString:color];
        }else{
            [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
        }
    }else{
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"setColorSilhoutteNeutral" description:@"Formato de cor não permitido."]];
    }
    
    
}

- (void)setImageIconPopupError: (id)image {
    imageIconPopupError = image;
}

#pragma mark - Cameras

/***Deprecated
 
 - (void)openLivenessX {
     
     if ([self verifyTarget]) {
         [self callLivenessXView];
     }
     
 }
 



- (void)openLivenessXWithCreateProcess: (NSString *)code name:(NSString *) name {
    
    [self openLivenessXWithCreateProcess:code name:name gender:nil birthdate:nil email:nil phone:nil];
    
}

- (void)openLivenessXWithCreateProcess: (NSString *)code name:(NSString *) name gender: (NSString *)gender birthdate: (NSString *)birthdate email: (NSString *)email phone : (NSString *)phone {
    
    if([self verifyDataREST]) {
        if ([self verifyTarget]) {
            
            CreateProcess *objProcess = [CreateProcess new];
            objProcess.code = code;
            objProcess.name = name;
            
            if(gender != nil) {
                objProcess.gender = gender;
            }
            
            if(birthdate != nil) {
                objProcess.birthdate = birthdate;
            }
            
            if(email != nil) {
                objProcess.email = email;
            }
            
            if(phone != nil) {
                objProcess.phone = phone;
            }
            
            self.createProcess = objProcess;
            
            [self callLivenessXView];
            
        }
    }
    
}
 
 */


- (void)openCameraFace {
    
    if ([self verifyTarget]) {
        
        cView = [CameraFaceView new];
        [cView setAcessiBioManager:self];
        [cView setURL:url];
        [cView setAPIKEY:apikey];
        [cView setTOKEN:token];
        [cView setIsEnableAutoCapture:isAutoCapture];
        [cView setIsEnableSmartCapture:isSmartCamera];
        [cView setColorSilhoutteNeutral:colorSilhoutteNeutral];
        [cView setColorSilhoutteError:colorSilhoutteError];
        [cView setColorSilhoutteSuccess:colorSilhoutteSuccess];
        [cView setColorBackground:colorBackground];
        [cView setColorBackgroundBoxStatus:colorBackgroundBoxStatus];
        [cView setColorTextBoxStatus:colorTextBoxStatus];
        [cView setLanguage:language];
        [cView setVersionRelease:versionRelease];
        [cView setSecondsTimeoutProcess:secondsTimeoutProcess];
        [cView setSecondsTimeoutToInferenceFace:secondsTimeoutToFaceInference];
        [self presentView:cView];
        
    }
    
}

- (void)openCameraFaceWithCreateProcess: (NSString *)code name:(NSString *) name {
    
    if([self verifyDataREST]) {
        if ([self verifyTarget]) {
            
            CreateProcess *objProcess = [CreateProcess new];
            objProcess.code = code;
            objProcess.name = name;
            
            self.createProcess = objProcess;
            
            cView = [CameraFaceView new];
            [cView setAcessiBioManager:self];
            [cView setURL:url];
            [cView setAPIKEY:apikey];
            [cView setTOKEN:token];
            [cView setIsEnableAutoCapture:isAutoCapture];
            [cView setIsEnableSmartCapture:isSmartCamera];
            [cView setColorSilhoutteNeutral:colorSilhoutteNeutral];
            [cView setColorSilhoutteError:colorSilhoutteError];
            [cView setColorSilhoutteSuccess:colorSilhoutteSuccess];
            [cView setColorBackground:colorBackground];
            [cView setColorBackgroundBoxStatus:colorBackgroundBoxStatus];
            [cView setColorTextBoxStatus:colorTextBoxStatus];
            [cView setLanguage:language];
            [cView setVersionRelease:versionRelease];
            [cView setSecondsTimeoutProcess:secondsTimeoutProcess];
            [cView setSecondsTimeoutToInferenceFace:secondsTimeoutToFaceInference];
            [self presentView:cView];
            
        }
    }
    
}

- (void)openCameraFaceWithCreateProcess: (NSString *)code name:(NSString *) name gender: (NSString *)gender birthdate: (NSString *)birthdate email: (NSString *)email phone : (NSString *)phone {
    
    if([self verifyDataREST]) {
        if ([self verifyTarget]) {
            
            CreateProcess *objProcess = [CreateProcess new];
            objProcess.code = code;
            objProcess.name = name;
            objProcess.gender = gender;
            objProcess.birthdate = birthdate;
            objProcess.email = email;
            objProcess.phone = phone;
            
            self.createProcess = objProcess;
            
            cView = [CameraFaceView new];
            [cView setAcessiBioManager:self];
            [cView setURL:url];
            [cView setAPIKEY:apikey];
            [cView setTOKEN:token];
            [cView setIsEnableAutoCapture:isAutoCapture];
            [cView setIsEnableSmartCapture:isSmartCamera];
            [cView setLanguage:language];
            [cView setVersionRelease:versionRelease];
            [cView setSecondsTimeoutProcess:secondsTimeoutProcess];
            [cView setSecondsTimeoutToInferenceFace:secondsTimeoutToFaceInference];
            [self presentView:cView];
            
        }
    }
    
}

- (void)openCameraDocuments : (DocumentType) documentType {
    
    dView = [DocumentInsertView new];
    
    if(documentType == DocumentCNH) {
        dView.type = 4;
    }else if(documentType == DocumentRGFrente || documentType == DocumentRG) {
        dView.type = 501;
    }else if(documentType == DocumentRGVerso){
        dView.type = 502;
    }else{
        dView.type = 999;
    }
    
    dView.acessoBioManager = self;
    [self presentView:cView];
    
}

- (void)openCameraDocumentOCR : (DocumentType) documentType {
    
    dView = [DocumentInsertView new];
    
    [dView setAcessoBioManager:self];
    [dView setURL:url];
    [dView setAPIKEY:apikey];
    [dView setTOKEN:token];
    [dView setOperationType:OCR];
    
    if(documentType == DocumentCNH) {
        dView.type = 4;
    }else if(documentType == DocumentRGFrente || documentType == DocumentRG) {
        dView.type = 501;
    }else if(documentType == DocumentRGVerso){
        dView.type = 502;
    }else{
        dView.type = 999;
    }
    [self presentView:cView];

    
}

- (void)openCameraDocumentFacematch : (DocumentType) documentType {
    
    isFacematchProcess = YES;
    documentTypeFacematch = documentType;
    isSmartCamera = NO;
    isAutoCapture = NO;
    
    [self openCameraFace];
    
}

- (void)openDocumentFaceMatch {
    
    dView = [DocumentInsertView new];
    
    [dView setAcessoBioManager:self];
    [dView setURL:url];
    [dView setAPIKEY:apikey];
    [dView setTOKEN:token];
    [dView setBase64SelfieToFaceMatch:base64Facematch];
    [dView setOperationType:Facematch];
    
    if(documentTypeFacematch == DocumentCNH) {
        dView.type = 4;
    }else if(documentTypeFacematch == DocumentRGFrente || documentTypeFacematch == DocumentRG) {
        dView.type = 501;
    }else if(documentTypeFacematch == DocumentRGVerso){
        dView.type = 502;
    }else{
        dView.type = 999;
    }
    [self presentView:dView];

    
}

- (void)facesCompare: (NSString *)cpf{
    
    cView = [CameraFaceView new];
    [cView setAcessiBioManager:self];
    [cView setURL:url];
    [cView setAPIKEY:apikey];
    [cView setTOKEN:token];
    [cView setIsEnableAutoCapture:isAutoCapture];
    [cView setIsEnableSmartCapture:isSmartCamera];
    [cView setIsFacesCompareOneToOne:YES];
    [cView setCpfToFacesCompare:cpf];
    [cView setLanguage:language];
    [cView setVersionRelease:versionRelease];
    [self presentView:cView];
    
}

- (void)presentView:(UIViewController *)vc {
    if(!hasImplementationError) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [nav setNavigationBarHidden:YES animated:NO];
        [nav setModalPresentationStyle:UIModalPresentationFullScreen];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Instances

/***Deprecated
 
 - (void)callLivenessXView {
     
     lView = [LivenessXView new];
     [lView setAcessiBioManager:self];
     [lView setURL:url];
     [lView setAPIKEY:apikey];
     [lView setTOKEN:token];
     [lView setColorSilhoutteNeutral:colorSilhoutteNeutral];
     [lView setColorSilhoutteError:colorSilhoutteError];
     [lView setColorSilhoutteSuccess:colorSilhoutteSuccess];
     [lView setColorBackground:colorBackground];
     [lView setColorBackgroundBoxStatus:colorBackgroundBoxStatus];
     [lView setColorTextBoxStatus:colorTextBoxStatus];
     [lView setColorBackgroundPopupError:colorBackgroundPopupError];
     [lView setColorTextPopupError:colorTextPopupError];
     [lView setColorBackgroundButtonPopupError:colorBackgroundButtonPopupError];
     [lView setColorTitleButtonPopupError:colorTitleButtonPopupError];
     [lView setImageIconPopupError:imageIconPopupError];
     [lView setLanguage:language];
     [lView setVersionRelease:versionRelease];
     UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lView];
     [nav setNavigationBarHidden:YES animated:NO];
     [nav setModalPresentationStyle:UIModalPresentationFullScreen];
     [viewController presentViewController:nav animated:YES completion:nil];
     
 }
 
 */


#pragma mark - Utils

- (BOOL)verifyTarget {
    
    if (@available(iOS 11.0, *)) {
        return YES;
    }else{
        
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"verifyTarget" description:@"Este método está disponível a partir do iOS 11."]];
            
        return NO;
    }
}

- (BOOL)verifyColorString : (NSString *)string{
    NSCharacterSet *chars = [[NSCharacterSet
                              characterSetWithCharactersInString:@"#0123456789ABCDEF"] invertedSet];
    
    BOOL isValid = (NSNotFound == [string rangeOfCharacterFromSet:chars].location);
    if(string.length == 0) {
        isValid = NO;
    }
    return isValid;
}

- (BOOL)verifyDataREST {
    
    NSURL *urlToValidate = [NSURL URLWithString:url];
    if (!urlToValidate || !urlToValidate.scheme || !urlToValidate.host)
    {
        
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"verifyDataREST" description:@"A URL fornecida é inválida."]];
        return NO;
    }else if(apikey.length == 0) {
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"verifyDataREST" description:@"A APIKEY fornecida está vazia."]];
        return NO;
    }else if(token.length == 0) {
        [self onErrorAcessoBioManager:[[ErrorBio alloc]initCode:400 method:@"verifyDataREST" description:@"O TOKEN fornecido está vazio."]];
        
        return NO;
    }
    
    return YES;
    
}


#pragma mark - Callbacks

- (void)userClosedCameraManually {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClosedCameraManually)]) {
        [self.delegate userClosedCameraManually];
    }
    
}

- (void)systemClosedCameraTimeoutProcess {
    if (self.delegate && [self.delegate respondsToSelector:@selector(systemClosedCameraTimeoutProcess)]) {
        [self.delegate systemClosedCameraTimeoutProcess];
    }
}

- (void)systemClosedCameraTimeoutFaceInference {
    if (self.delegate && [self.delegate respondsToSelector:@selector(systemClosedCameraTimeoutFaceInference)]) {
        [self.delegate systemClosedCameraTimeoutFaceInference];
    }
}

/** * Deprecated
 
 - (void)onSuccesLivenessX: (LivenessXResult *)result {
     
     if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccesLivenessX:)]) {
         [self.delegate onSuccesLivenessX:result];
     }else{
         NSLog(@"Método onSuccesLivenessX não implementado. Implemente-o e tente novamente...");
     }
     
 }

 - (void)onErrorLivenessX:(NSString *)error {
     
     if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorLivenessX:)]) {
         [self.delegate onErrorLivenessX:error];
     }else{
         NSLog(@"Método onErrorLivenessX não implementado. Implemente-o e tente novamente...");
     }
     
 }
 
 */

- (void)onSuccesCameraFace:(CameraFaceResult *)result {
    
    if(isFacematchProcess){
        
        isFacematchProcess = NO;
        base64Facematch = result.base64;
        
        [self performSelector:@selector(openDocumentFaceMatch) withObject:nil afterDelay:0.5];
        
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccesCameraFace:)]) {
        [self.delegate onSuccesCameraFace:result];
    }else{
        NSLog(@"Método onSuccesCameraFace não implementado. Implemente-o e tente novamente...");
    }
    
}

- (void)onErrorCameraFace:(ErrorBio *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorCameraFace:)]) {
        [self.delegate onErrorCameraFace:error];
    }else{
        NSLog(@"Método onErrorCameraFace não implementado. Implemente-o e tente novamente...");
    }
    
}

- (void)onSuccesCameraDocument: (CameraDocumentResult *)result{
    
    if(dView.type == 501) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccesCameraDocument:)]) {
            [self.delegate onSuccesCameraDocument:result];
        }
        
        [self openCameraDocuments:DocumentRGVerso];
        
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccesCameraDocument:)]) {
            [self.delegate onSuccesCameraDocument:result];
        }
    }
    
}

- (void)onErrorCameraDocument:(ErrorBio *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorCameraDocument:)]) {
        [self.delegate onErrorCameraDocument:error];
    }else{
        NSLog(@"Método onErrorCameraDocument não implementado. Implemente-o e tente novamente...");
    }
    
}

- (void)onSuccessOCR: (OCRResult *)result{
    
    if(dView.type == 501) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccessOCR:)]) {
            [self.delegate onSuccessOCR:result];
        }
        
        [self openCameraDocuments:DocumentRGVerso];
        
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccessOCR:)]) {
            [self.delegate onSuccessOCR:result];
        }
    }
    
}

- (void)onErrorOCR: (ErrorBio *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorOCR:)]) {
        [self.delegate onErrorOCR:error];
    }else{
        NSLog(@"Método onErrorFacesCompare não implementado. Implemente-o e tente novamente...");
    }
    
}

- (void)onSuccessFacematch: (FacematchResult *)result {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccessFacematch:)]) {
        [self.delegate onSuccessFacematch:result];
    }
    
}

- (void)onErrorFacematch: (ErrorBio *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorFacematch:)]) {
        [self.delegate onErrorFacematch:error];
    }else{
        NSLog(@"Método onErrorFacesCompare não implementado. Implemente-o e tente novamente...");
    }
    
}

- (void)onSuccessFacesCompare:(BOOL)status {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSuccessFacesCompare:)]) {
        [self.delegate onSuccessFacesCompare:status];
    }
    
}

- (void)onErrorFacesCompare:(ErrorBio *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorFacesCompare:)]) {
        [self.delegate onErrorFacesCompare:error];
    }else{
        NSLog(@"Método onErrorFacesCompare não implementado. Implemente-o e tente novamente...");
    }
    
}

- (void)onErrorAcessoBioManager:(ErrorBio *)error {
    hasImplementationError = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorAcessoBioManager:)]) {
        [self.delegate onErrorAcessoBioManager:error];
    }else{
        NSLog(@"Método onErrorAcessoBioManager não implementado. Implemente-o e tente novamente...");
    }
}


@end
