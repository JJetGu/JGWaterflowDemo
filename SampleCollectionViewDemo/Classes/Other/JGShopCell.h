//
//  JGShopCell.h
//  SampleCollectionViewDemo
//
//  Created by JJetGu on 15/6/28.
//  Copyright (c) 2015年 Free. All rights reserved.
//

#import "JGWaterflowViewCell.h"

@class JGWaterflowView, JGShop;

@interface JGShopCell : JGWaterflowViewCell

+ (instancetype)cellWithWaterflowView:(JGWaterflowView *)waterflowView;

@property (nonatomic, strong) JGShop *shop;

@end
