//
//  ScanToolVC.m
//  QianShanJY
//
//  Created by Fedora on 2018/11/13.
//  Copyright © 2018 chinasun. All rights reserved.
//

#import "ScanToolVC.h"
#import "ScanQRCodeBkView.h"

#define APP_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define APP_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ScanToolVC ()
{
    CGFloat width;
    NSString *strCode;
}
@property(nonatomic,strong) UILabel *label;
@property (strong, nonatomic) CALayer *scanLayer;
@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, retain) UIImageView * line;
@property (nonatomic) BOOL cameraSupport;

@end

@implementation ScanToolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor halfAlphaColor];
    self.title = @"扫描";
    
    ScanQRCodeBkView *bkView = [[ScanQRCodeBkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:bkView];
    
    CGRect rect = self.view.frame;
    width = CGRectGetWidth(rect)*2/3;
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(rect)/6, 100, width, width)];
    scanView.backgroundColor = [UIColor clearColor];
    scanView.clipsToBounds = YES;
    [self.view addSubview:scanView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    imageView.image = [UIImage imageNamed:@"bind_scan_frame"];
    [scanView addSubview:imageView];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, -width, width, width)];
    _line.image = [UIImage imageNamed:@"bind_scan_line"];
    [imageView addSubview:_line];
    
    
    CGRect imgRect = scanView.frame;
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.frame=CGRectMake(20, CGRectGetMaxY(imgRect)+25, CGRectGetWidth(rect)-40, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.numberOfLines = 2;
    labIntroudction.textColor=[UIColor whiteColor];
    NSString *msg = @"扫描二维码";
    
    labIntroudction.text=msg;
    [self.view addSubview:labIntroudction];
    CGRect lbRect = labIntroudction.frame;
    
    UIButton *bt_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    bt_cancel.frame = CGRectMake(CGRectGetMinX(imgRect), CGRectGetMaxY(lbRect)+25, width, 38);
    //    bt_cancel.layer.borderWidth = 1.2;
    //    bt_cancel.layer.borderColor =  [[UIColor whiteColor] CGColor];
    bt_cancel.backgroundColor = [UIColor lightGrayColor];
    bt_cancel.layer.cornerRadius = 5;
    [bt_cancel setTitle:@"取消绑定" forState:UIControlStateNormal];
    [bt_cancel setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [bt_cancel addTarget:self action:@selector(clickedCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt_cancel];
    
    if ([self canVideo]) {
        _cameraSupport = YES;
        [self takePhoto];
        [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^ {
            _line.frame = CGRectMake(0, 0, width, width);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
    }
}

- (void)clickedCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![_session isRunning] && (_cameraSupport == YES)) {
        [_session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 停止扫描二维码
    [_session stopRunning];
}

-(void)takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        _cameraSupport = YES;
        [self avc];
    }else {
        _cameraSupport = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"设备不支持" delegate:nil cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void)avc{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType : AVMediaTypeVideo ];
    // Input
    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self . device error : nil ];
    // Output
    _output = [[ AVCaptureMetadataOutput alloc ] init ];
    [ _output setRectOfInterest : CGRectMake (( 100 )/ APP_SCREEN_HEIGHT ,( width/4 )/ APP_SCREEN_WIDTH , width / APP_SCREEN_HEIGHT , width / APP_SCREEN_WIDTH )];
    [ _output setMetadataObjectsDelegate : self queue : dispatch_get_main_queue ()];
    
    // Session
    _session = [[ AVCaptureSession alloc ] init ];
    [ _session setSessionPreset : AVCaptureSessionPresetHigh ];
    if ([ _session canAddInput : self.input ])
    {
        [ _session addInput : self.input ];
    }
    if ([ _session canAddOutput : self.output ])
    {
        [ _session addOutput : self.output ];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    // Preview
    
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
    
    _preview . videoGravity = AVLayerVideoGravityResizeAspectFill ;
    
    _preview . frame = self . view . layer . bounds ;
    
    [ self . view . layer insertSublayer : _preview atIndex : 0 ];
    
    // Start
    [ _session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    if ([metadataObjects count ] > 0 )
    {
        // 停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex: 0 ];
        NSString *str = metadataObject.stringValue ;
        if (_scanQRCodeDelegate && [_scanQRCodeDelegate respondsToSelector:@selector(returnScanQRCode:)]) {
            [_scanQRCodeDelegate returnScanQRCode:str];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



- (BOOL)canVideo {
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if((authstatus != AVAuthorizationStatusAuthorized) && (authstatus != AVAuthorizationStatusNotDetermined))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的“设置-隐私-相机“选项中，允许千山降压访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *bt_ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                      }];
        
        [alertController addAction:bt_ok];
        alertController.view.tintColor = [UIColor darkGrayColor];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    else {
        return YES;
    }
}

@end
