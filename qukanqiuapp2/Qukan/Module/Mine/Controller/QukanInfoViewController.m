#import "QukanInfoViewController.h"
#import "QukanPhoneVerificationViewController.h"
#import "QukanModifyNameViewController.h"
//#import "QukanMatchInfoModel.h"
#import "QukanInfoCell.h"

#import "QukanYYImageClipViewController.h"
#import "QukanBindEmailVC.h"

@interface QukanInfoViewController ()

<UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
YYImageClipDelegate>

@property (nonatomic, strong) UITableView *Qukan_myTableView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@end
@implementation QukanInfoViewController

- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 200.0f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _portraitImageView.center = self.view.center;
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = kCommonBlackColor.CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [kCommonBlackColor CGColor];
        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = kCommonBlackColor;
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = kCommentBackgroudColor;
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        [self.view addSubview:_Qukan_myTableView];
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _Qukan_myTableView.tableFooterView = [UIView new];
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanInfoCell" bundle:nil] forCellReuseIdentifier:@"QukanInfoCell"];
//        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).mas_offset(0.0);
            make.left.equalTo(self.view).mas_offset(10.0);
            make.right.equalTo(self.view).mas_offset(-10.0);
            make.bottom.equalTo(self.view).mas_offset(0.0);
        }];
    }
    return _Qukan_myTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.Qukan_myTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    [self Qukan_myTableView];
    self.view.backgroundColor = kCommentBackgroudColor;
}
- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self.Qukan_myTableView.mj_header beginRefreshing];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0 ? 1:4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==0 ? 100.0:55.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanInfoCell"];
    if (indexPath.section==1 && indexPath.row==4) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0.0, 0.0)];
    } else {
        [cell setSeparatorInset:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
    }
    
    if (indexPath.section==0) {
        cell.headImageView.hidden = NO;
        cell.contentLabel.hidden = YES;
        cell.nameLabel.text = @"头像";
        NSString *headImgUrl = kUserManager.user.avatorId;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"Qukan_user_DefaultAvatar"]];
    } else {
        cell.contentLabelRight.constant = 38.0;
        cell.rightImageView.hidden = NO;
        cell.headImageView.hidden = YES;
        cell.contentLabel.hidden = NO;
        switch (indexPath.row) {
            case 0:{
                cell.contentLabelRight.constant = 20.0;
                cell.rightImageView.hidden = YES;
                cell.nameLabel.text = @"账号ID";
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",kUserManager.user.appId];
            } break;
            case 1:{
                cell.nameLabel.text = @"名字";
                cell.contentLabel.text = kUserManager.user.nickname;
            } break;
            case 2:{
                NSString *phone = kUserManager.user.tel;
                cell.contentLabelRight.constant = 20.0;
                cell.rightImageView.hidden = phone.length==0?NO:YES;
                cell.nameLabel.text = @"手机号";
                cell.contentLabel.text = [phone substringFromIndex:2];
            } break;
//            case 3:{
//                cell.nameLabel.text = @"修改密码";
//                cell.contentLabel.text = @"";
//            } break;
            case 3:{
                cell.nameLabel.text = @"邮箱";
                // 判断字符串不为空并且不为空字符串
                cell.contentLabelRight.constant = 30;
                NSString *email =  [NSString stringWithFormat:@"%@",kUserManager.user.email];
                cell.contentLabel.text = (![email isEqualToString: @"(null)"] && ![email isEqualToString:@""])?email: @"绑定邮箱";
            } break;
            default:break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        [self Qukan_updateHeadImage];
    } else {
        if (indexPath.row==0) {
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = [NSString stringWithFormat:@"%@",kUserManager.user.appId];
            [SVProgressHUD showSuccessWithStatus:@"账号ID复制成功"];
        } else if (indexPath.row==1) {
            QukanModifyNameViewController *vc = [[QukanModifyNameViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row==2) {
            NSString *phone = kUserManager.user.tel;
            if (phone.length==0) {
                QukanPhoneVerificationViewController *vc = [[QukanPhoneVerificationViewController alloc] init];
                vc.isLogin = YES;
//                vc.thirdId = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_ThirdId_Key];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
//        else if (indexPath.row==3) {
//            QukanModifyPassViewController *vc = [[QukanModifyPassViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        else if (indexPath.row == 3) {
//            NSString *email =  [NSString stringWithFormat:@"%@",kUserManager.user.email];
//            if ([email isEqualToString: @"(null)"] || [email isEqualToString:@""]) {
                QukanBindEmailVC *vc = [QukanBindEmailVC new];
                @weakify(self);
                vc.bindEmialSuccessBlock = ^{
                    @strongify(self);
                    [self.Qukan_myTableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
//            }
        }
    }
}
- (void)Qukan_updateHeadImage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
//    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self Qukan_openAlbum];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self Qukan_openCamera];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)Qukan_openAlbum {
    UIImagePickerController *imagePicker= [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)Qukan_openCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"没有摄像头" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
    }
}

- (void)Qukan_uploadHeadImgWithImage:(UIImage *)headImg {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    UIImage *ys_heaerImg = [self compressImageSize:headImg toByte:100 * 1024];
    
//    NSLog(@"%zd", UIImageJPEGRepresentation(ys_heaerImg, 1).length);
//    NSLog(@"%zd", UIImageJPEGRepresentation(headImg, 1).length);
    
    NSDictionary *parameters = @{@"photoFile":ys_heaerImg};
    [QukanNetworkTool Qukan_uploadImageWithUrl:@"gcuser/uploadHeadImg"
                                    parameters:parameters
                                  imageNameStr:@"0"
                                       success:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([response[@"status"] integerValue]==200) {
//            NSString *headImgUrl = response[@"data"]?:@"";
//            kUserManager.user.avatorId = headImgUrl;
//            [self.Qukan_myTableView reloadData];
            [SVProgressHUD showSuccessWithStatus:FormatString(@"您的头像已上传成功，正在%@中，请耐心等待~",kStStatus.phone)];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    QukanYYImageClipViewController *imgCropperVC = [[QukanYYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NO];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(QukanYYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    @weakify(self)
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        [self Qukan_uploadHeadImgWithImage:self.portraitImageView.image];
    }];
}

- (void)imageCropperDidCancel:(QukanYYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < kScreenWidth) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = kScreenWidth;
        btWidth = sourceImage.size.width * (kScreenWidth / sourceImage.size.height);
    } else {
        btWidth = kScreenWidth;
        btHeight = sourceImage.size.height * (kScreenWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - camera utility
- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


/*!
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *  @param image 当前要压缩的图 maxLength 压缩后的大小
 *
 *  @return 图片对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
- (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
