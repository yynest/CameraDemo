//
//  ViewController.m
//  CameraDemo
//
//  Created by Fedora on 2018/11/22.
//  Copyright © 2018 Fedora. All rights reserved.
//

#import "ViewController.h"
#import "ScanToolVC.h"

#import "TZImagePickerController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ScanToolVCDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray<NSArray<NSString *> *> *actionList;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照相Dome";
    [self configureData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)configureData {
    
    actionList = [NSMutableArray array];
    
    [actionList addObject:@[@"扫描二维码", @"scanQRCode"]];
    [actionList addObject:@[@"遮罩层", @"addMaskView"]];
    [actionList addObject:@[@"圆形裁剪框", @"addCircleCrop"]];
    [actionList addObject:@[@"单元格", @"addCellView"]];
}

- (void)scanQRCode {
    ScanToolVC *bindTipsVC = [[ScanToolVC alloc] init];
    bindTipsVC.scanQRCodeDelegate = self;
    [self.navigationController pushViewController:bindTipsVC animated:YES];
}

- (void)addMaskView {
    
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImageView *maskImageView = [self cameraHelpView];
    [imagePicker.view addSubview:maskImageView];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    
}


- (UIImageView *)cameraHelpView {
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat width = self.view.frame.size.width;
    CGFloat offy= 40;
    
    imageView.frame = CGRectMake(0, offy, width, width/0.75);
    imageView.image = [UIImage imageNamed:0 == 0 ? @"authCamera1": @"authCamera2"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, 20)];
    titleLabel.text = 0 == 0 ? [NSString stringWithFormat:@"%@",@"拍摄身份证人像面"]:[NSString stringWithFormat:@"%@",@"拍摄身份证国徽面"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+10, width, 20)];
    tipLabel.text = [NSString stringWithFormat:@"%@",@"将身份证置于虚线框内，确保文字清晰"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:16];
    
    [imageView addSubview:titleLabel];
    [imageView addSubview:tipLabel];
    
    return imageView;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo {
    
}
                                                                                                                    
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
                                                                                                                        
}
                                                                                                                    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
                                                                                                                        
}

- (void)addCircleCrop {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    

    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.frame.size.width - 2 * left;
    NSInteger top = (self.view.frame.size.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);

    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)addCellView {
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return actionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *actions = actionList[indexPath.row];
    cell.textLabel.text = actions[0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL funSel = NSSelectorFromString(actionList[indexPath.row][1]);
    if (funSel) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:funSel];
#pragma clang diagnostic pop
    }
}


#pragma ScanToolVCDelegate
- (void)returnScanQRCode:(NSString *)code {
    
}

@end
