//
//  SmartHomeCaptureView.m
//  KKLibraryDemo_Pod
//
//  Created by liubo on 2021/7/13.
//

#import "SmartHomeCaptureView.h"

@interface SmartHomeCaptureView ()

@property (nonatomic , strong) UIView *backgroundView;
@property (nonatomic , strong) NSTimer *myTimer;

@end

@implementation SmartHomeCaptureView

- (void)dealloc
{
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        KKWeakSelf(self);
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 block:^{
            [weakself myTimerRunLoop];
        } repeats:YES];
    }
    return self;
}

- (void)myTimerRunLoop{
    NSInteger index = [NSNumber randomIntegerBetween:1 and:4];
    if (index==1) {
        self.backgroundColor = [UIColor redColor];
    }
    else if (index==2){
        self.backgroundColor = [UIColor blueColor];
    }
    else if (index==3){
        self.backgroundColor = [UIColor greenColor];
    }
    else{
        self.backgroundColor = [UIColor RandomColorRGB];
    }
}

@end
