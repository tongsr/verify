//
//  VerifyCodeVC.h
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

typedef void(^verifyCodeBlock)();
@interface VerifyCodeVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblGuide;

@property (nonatomic , copy)verifyCodeBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIView *verifyView;

@property (weak, nonatomic) IBOutlet UIView *closeView;

@property (weak, nonatomic) IBOutlet UIView *dragFrame;
@property (weak, nonatomic) IBOutlet UIView *dragView;


@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFollow;
@property (weak, nonatomic) IBOutlet UIImageView *imgTarget;

@end
