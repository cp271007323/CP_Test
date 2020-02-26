
@interface QukanViewController ()
@end
@implementation QukanViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.view.backgroundColor = Qukan_View_BackgroundColor;
    self.view.backgroundColor = kCommentBackgroudColor;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
