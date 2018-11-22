//
//  ScanToolVC.h
//  QianShanJY
//
//  Created by Fedora on 2018/11/13.
//  Copyright © 2018 chinasun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScanToolVCDelegate <NSObject>

- (void)returnScanQRCode:(NSString *)code;

@end


@interface ScanToolVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong) id scanQRCodeDelegate;

@end

NS_ASSUME_NONNULL_END
