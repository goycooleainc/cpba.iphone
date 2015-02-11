//
//  SecurityViewController.h
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "ViewController.h"

@interface SecurityViewController : ViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    /// picker index
    NSInteger pickerActiveIdx;
}
//// MutableArray
@property (nonatomic, retain) IBOutlet NSMutableArray *securityCollection;
/// Button outlet
@property (nonatomic, retain) IBOutlet UIButton *buttonSend;
/// picker View object
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@end
