//
//  ALPValidatorDemoTextFieldViewController.h
//  ALPValidator
//
//  Created by Adam Waite on 03/02/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALPValidator;

@interface ALPValidatorDemoTextFieldViewController : UIViewController

- (void)configureWithDescription:(NSString *)desc validator:(ALPValidator *)validator;

@end
