//
//  ViewController.m
//  verify
//

#import "ViewController.h"
#import "VerifyCodeVC.h"



@interface ViewController ()
- (IBAction)verivyFunc:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)verivyFunc:(id)sender {

    VerifyCodeVC *verifyVC=[[VerifyCodeVC alloc]initWithNibName:@"VerifyCodeVC" bundle:nil];
    verifyVC.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    verifyVC.block = ^{
        
        [[[UIAlertView alloc]initWithTitle:@"验证成功" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
        
    };
    [self presentViewController:verifyVC animated:YES completion:nil];
}
@end
