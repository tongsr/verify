//
//  VerifyCodeVC.m
//

#import "VerifyCodeVC.h"


//是否为iPhone5
#ifndef iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?  \
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

//是否为iPhone4
#ifndef iPhone4
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?  \
CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#endif


@interface VerifyCodeVC ()

@end

@implementation VerifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewMoved:)];
    
    [self.dragView addGestureRecognizer:panGestureRecognizer];


    
    UITapGestureRecognizer *tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFunc)];
    [self.closeView addGestureRecognizer:tapges];
    
    
    int i=1+arc4random()%3;
    NSString *nameStr=[NSString stringWithFormat:@"verify_bg%d",i];
    self.imgBg.image=[UIImage imageNamed:nameStr];
    
    
    if (iPhone4||iPhone5) {
        CGPoint center=self.verifyView.center;
        self.verifyView.frame=CGRectMake(0, 0, self.verifyView.frame.size.width*0.8, self.verifyView.frame.size.height*0.8);
        self.verifyView.center=center;
    }
    
    
    
    
    
    int x=50+arc4random()%((int)self.imgBg.frame.size.width-100);
    int y=10+arc4random()%((int)self.imgBg.frame.size.height-20-(int)self.imgFollow.frame.size.height);
    
    [self.imgTarget setFrame:CGRectMake(x, y, self.imgTarget.frame.size.width, self.imgTarget.frame.size.height)];

    [self.followView setFrame:CGRectMake(2, y, self.followView.frame.size.width, self.followView.frame.size.height)];

    

    [self followImgInit];
}



-(void)followImgInit{
    
    float width = CGImageGetWidth(self.imgBg.image.CGImage);
    float height = CGImageGetHeight(self.imgBg.image.CGImage);
    
    CGRect rectbg=self.imgBg.bounds;
    CGRect rectTarget=self.imgTarget.frame;
    
    
    CGRect rect=CGRectMake(width*(rectTarget.origin.x/rectbg.size.width), height*(rectTarget.origin.y/rectbg.size.height), width*rectTarget.size.width/rectbg.size.width, height*rectTarget.size.height/rectbg.size.height);
    
    
    
    CGImageRef imageRef=CGImageCreateWithImageInRect(self.imgBg.image.CGImage,rect);
    UIImage *image1=[UIImage imageWithCGImage:imageRef];
    UIImage *maskImage = [UIImage imageNamed:@"verify_mask_black"];
    self.imgFollow.image=[self maskImage:image1 withMask:maskImage];
    //self.imgFollow.image=[self maskImage:image1 withMask:[UIImage imageNamed:@"verify_mask_white"]];
    
    //self.imgFollow.image=image1;
}







-(void)closeFunc{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)dragViewMoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
    self.lblGuide.hidden=YES;
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        self.dragView.center = CGPointMake(self.dragView.center.x + translation.x, self.dragView.center.y);
        if (self.dragView.frame.origin.x<2) {
            [self.dragView setFrame:CGRectMake(2, 2, self.dragView.frame.size.width, self.dragView.frame.size.height)];
        }
        if (self.dragView.frame.origin.x>(self.dragFrame.frame.size.width-self.dragView.frame.size.width-2)) {
            [self.dragView setFrame:CGRectMake(self.dragFrame.frame.size.width-self.dragView.frame.size.width-2, 2, self.dragView.frame.size.width, self.dragView.frame.size.height)];
        }
        [self.followView setFrame:CGRectMake(self.dragView.frame.origin.x, self.followView.frame.origin.y, self.followView.frame.size.width, self.followView.frame.size.height)];
        //关键，不设为零会不断递增，视图会突然不见
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.block&&fabs(self.followView.frame.origin.x-self.imgTarget.frame.origin.x)<5) {
            self.block();
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
            //[MBProgressHUD showError:@"验证失败"];
            [[[UIAlertView alloc]initWithTitle:@"验证失败" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
        }
    }
}






////为图像创建透明区域
- (CGImageRef)CopyImageAndAddAlphaChannel:(CGImageRef)sourceImage
{
    CGImageRef retVal = NULL;
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace,
        kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    if (offscreenContext != NULL)
    {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    CGColorSpaceRelease(colorSpace);
    return retVal;
}



/////利用图像遮盖
- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        8,
                                        32,
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    

    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    //if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        imageWithAlpha = [self CopyImageAndAddAlphaChannel:sourceImage];
    //}
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);

    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
      
}


@end
