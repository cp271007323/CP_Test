#import "QukanPublishViewController.h"
//#import "QukanImagePickerSheet.h"
#import "QukanPublishCell.h"

#import "QukanAddViewController.h"
#import "QukanAppDelegate.h"
#import "QukanApiManager+Boiling.h"
#import <TZImagePickerController/TZImagePickerController.h>

@interface QukanPublishViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIButton *topicBtn;
@property (strong, nonatomic) NSMutableArray<UIImage *> *imageAataArray;
@property (strong, nonatomic) NSString *moduleId;

@end

@implementation QukanPublishViewController

- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"QukanPublishCell" bundle:nil] forCellWithReuseIdentifier:@"QukanPublishCell"];
        [self.view addSubview:_myCollectionView];
        [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
//            make.top.equalTo(self.view).mas_offset(165.0);
            make.top.mas_equalTo(self.topicBtn.mas_bottom).mas_offset(10.0);
            make.height.mas_equalTo((CGRectGetWidth([[UIScreen mainScreen] bounds])-40.0)/3.0);
        }];
    }
    return _myCollectionView;
}
- (UIButton *)topicBtn {
    if (!_topicBtn) {
        _topicBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_topicBtn setTitle:@"    添加话题 ▶    " forState:UIControlStateNormal];
        _topicBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_topicBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _topicBtn.layer.masksToBounds = YES;
        _topicBtn.layer.cornerRadius = 12.5;
        _topicBtn.layer.borderWidth = 0.5;
        _topicBtn.layer.borderColor = kThemeColor.CGColor;
        [_topicBtn addTarget:self action:@selector(addQukanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_topicBtn];
        [_topicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myTextView.mas_bottom).mas_offset(10.0);
            make.height.mas_equalTo(25.0);
            make.left.mas_equalTo(15.0);

        }];
    }
    return _topicBtn;
}

- (NSMutableArray<UIImage *> *)imageAataArray {
    if (!_imageAataArray) {
        _imageAataArray = [NSMutableArray new];
    }
    return _imageAataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布沸点";
    [self Qukan_setNavBarButtonItem];
    [self topicBtn];
    self.myTextView.tintColor = kThemeColor;
    self.myTextView.delegate = self;
    self.myTextView.text = @"输入沸点内容...";
    self.moduleId = @"";
    [self myCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setQukanNoti:) name:@"QukanAddViewController" object:nil];
}
- (void)setQukanNoti:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    NSLog(@"dict: %@", dict);
    if (dict) {
        NSInteger InfoId = [dict[@"InfoId"] integerValue];
        if (InfoId==0) {
            self.moduleId = @"";
            [self.topicBtn setTitle:@"    添加话题 ▶    " forState:UIControlStateNormal];
        } else {
            self.moduleId = [NSString stringWithFormat:@"%ld", InfoId];
            NSString *title = [NSString stringWithFormat:@"    %@ ▶    ", dict[@"Title"]];
            [self.topicBtn setTitle:title forState:UIControlStateNormal];
        }
    }
}
- (void)addQukanBtnClick {
    QukanAddViewController *addVc = [[QukanAddViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)Qukan_setNavBarButtonItem {
    UIButton *Qukan_rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [Qukan_rightBtn addTarget:self action:@selector(Qukan_rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    Qukan_rightBtn.backgroundColor = [UIColor clearColor];
    [Qukan_rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    UIBarButtonItem *Qukan_rightItem = [[UIBarButtonItem alloc]initWithCustomView:Qukan_rightBtn];
    self.navigationItem.rightBarButtonItem = Qukan_rightItem;
}

- (void)Qukan_rightBarButtonItemClick {
    kGuardLogin;
    
    if (self.myTextView.text.length==0 || [self.myTextView.text isEqualToString:@"输入沸点内容..."]) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"内容不能为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil]show];
    } else {
        [self.myTextView endEditing:YES];
        
       KShowHUD
        if (self.imageAataArray.count>0) {
           
            [QukanNetworkTool Qukan_uploadImageWithUrl:@"v3/posts/upload" images:self.imageAataArray success:^(NSDictionary *response) {
                if ([response[@"status"] integerValue]==200) {
                    NSArray *data = (NSArray *)response[@"data"];
                    NSString *imageUrl = @"";
                    for (int i=0; i<data.count; i++) {
                        NSString *s = data[i];
                        if (i==0) {
                            imageUrl = s;
                        } else {
                            imageUrl = [NSString stringWithFormat:@"%@,%@", imageUrl, s];
                        }
                    }
                    [self updateData:imageUrl];
                } else {
                    KHideHUD
                }
            } failure:^(NSError *error) {
                KHideHUD
            }];
            
        } else {
            [self updateData:nil];

        }
    }
}

- (void)updateData:(NSString *)imageUrl {

    NSString *moduleId = self.moduleId;
    NSString *content = self.myTextView.text;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:moduleId forKey:@"moduleId"];
    [parameters setObject:imageUrl?:@"" forKey:@"image_url"];
 
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanpostsWithContent:content addModuleId:moduleId addImageUrl:imageUrl] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self showPublishAlert];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD

        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)showPublishAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:FormatString(@"提交成功，请等待%@！",kStStatus.phone) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1){
        textView.text = @"输入沸点内容...";
        textView.textColor = [UIColor lightGrayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"输入沸点内容..."]){
        textView.text = @"";
        textView.textColor=kCommonBlackColor;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10.0, 0, 10.0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth([[UIScreen mainScreen] bounds])-40.0)/3.0;
    return CGSizeMake(width, width);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.imageAataArray.count;
    if (count<3) {
        return count+1;
    }
    else return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanPublishCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanPublishCell" forIndexPath:indexPath];
    NSInteger count = self.imageAataArray.count;
    if (count==0) {
        cell.deleteImageView.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.contentImageView.image = [UIImage imageNamed:@"Qukan_boiling_add"];
        
    } else {
        if (indexPath.row<count) {
            cell.deleteImageView.hidden = NO;
            cell.deleteButton.hidden = NO;
           
            UIImage *image = self.imageAataArray[indexPath.row];
            cell.contentImageView.image = image;
        } else {
            cell.deleteImageView.hidden = YES;
            cell.deleteButton.hidden = YES;
            cell.contentImageView.image = [UIImage imageNamed:@"Qukan_boiling_add"];
        }
        @weakify(self)
        cell.deleteDidBlock = ^{
            @strongify(self)
            [self.imageAataArray removeObjectAtIndex:indexPath.row];
            [self.myCollectionView reloadData];
        };
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imageAataArray.count>0 &&indexPath.row<self.imageAataArray.count) {
//        QukanPublishCell *Qukan_cell = (QukanPublishCell *)[collectionView cellForItemAtIndexPath:indexPath];

    } else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVc.maxImagesCount = 3;
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            for (UIImage *img in photos) {
                [self.imageAataArray addObject:img];
            }
            [self.myCollectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - QukanPhotoDelegate
-(void)Qukan_photoViwerWilldealloc:(NSInteger)selecedImageViewIndex{}

-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray {
    NSArray *array = [[NSArray alloc] initWithArray:ALAssetArray];
    self.imageAataArray = [[NSMutableArray alloc] init];
    [self.imageAataArray addObjectsFromArray:array];
    [self.myCollectionView reloadData];
}
//- (void)pickerViewFrameChanged {}
@end
