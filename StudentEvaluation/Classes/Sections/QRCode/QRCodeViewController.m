//
//  QRCodeViewController.m
//  dodoedu
//
//  Created by admin zheng on 16/1/19.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ImageAddition.h"

@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) AVCaptureDevice               *device;
@property (strong, nonatomic) AVCaptureDeviceInput          *input;
@property (strong, nonatomic) AVCaptureMetadataOutput       *output;
@property (strong, nonatomic) AVCaptureSession              *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer    *preview;

@property(nonatomic, retain) IBOutlet UIImageView *scanView;

@end

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self checkCameraAccessPermissionWithHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!granted) {
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"相机访问权限受限" message:@"请在iPhone的\"设置-隐私-相机\"中，允许多多社区访问您的相机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [self pop:nil];
                }];
                [vc addAction:confirm];
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                [self setContent];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
}

- (void)setContent
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_output setRectOfInterest:CGRectMake((124) / screenHeight, ((screenWidth - 220) / 2) / screenWidth, 220 / screenHeight, 220 / screenWidth)];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode, nil];
    
    // Preview
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

- (void)checkCameraAccessPermissionWithHandler:(void (^)(BOOL))handler
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                handler(granted);
            }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized:
        {
            handler(YES);
            break;
        }
            
        default:
        {
            handler(NO);
            break;
        }
    }
}

- (IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] > 0) {
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        if ([self.delegate respondsToSelector:@selector(didScanCode:)]) {
            [self.delegate didScanCode:stringValue];
        }
        
        [self pop:nil];
    }
    
    [self showPrompt:@"无效的二维码" HideDelay:2 withCompletionBlock:^{
        [self pop:nil];
    }];
}

@end
