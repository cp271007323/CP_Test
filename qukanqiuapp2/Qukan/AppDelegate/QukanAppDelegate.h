#import <UIKit/UIKit.h>
#import "QukanTarBarViewController.h"
#import "QukanMatchInfoModel.h"
#import "QukanDetailsViewController.h"
#import "QukanApiManager.h"
#import "QukanNewsModel.h"
#import "QukanNewsDetailsViewController.h"
#import "QukanPictureModel.h"

@interface QukanAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) QukanTarBarViewController *tarBar;

@end
