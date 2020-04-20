//
//  CQHAutoLoginView.h
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/15.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQHUserModel.h"

@interface CQHAutoLoginView : UIView

@property (nonatomic , strong) CQHUserModel *userModel;

+ (CQHAutoLoginView *)sharedAutoLoginView;

@end
