//
//  DocomoTestViewController.h
//  KKLibraryDemo_Pod
//
//  Created by edward lannister on 2021/3/18.
//

#import <KeKeLibrary/KeKeLibrary.h>


typedef NS_ENUM(NSInteger,DocomoTestType) {
    
    DocomoTestType_Scheme = 0,/* Scheme */
    
    DocomoTestType_Download = 1,/* Download */
        
};


@interface DocomoTestViewController : KKViewController

- (instancetype)initWithType:(DocomoTestType)aType;

@end
