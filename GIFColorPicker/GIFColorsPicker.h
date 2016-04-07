//
//  GIFColorPicker.h
//  GIFColorPickerApp
//
//  Created by Eric Young on 3/20/16.
//  Copyright © 2016 gifit. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GIFColorsPicker : UIControl

@property (nonatomic, assign) IBInspectable CGFloat ringWidth;
@property (nonatomic, strong) UIColor *selectedColor;

@end
