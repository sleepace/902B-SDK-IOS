//
//  SetLightViewController.m
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/30.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "SetLightViewController.h"
#import "ControlLightViewController.h"
#import <BleNox/BleNox.h>

@interface SetLightViewController ()

@property (weak, nonatomic) IBOutlet UITextField *colorRTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorGTextfFiled;
@property (weak, nonatomic) IBOutlet UITextField *colorBTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *colorWTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *brightnessTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *sendColorBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendBrightnessBtn;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;

@end

@implementation SetLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = LocalizedString(@"setLight");
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFiledEditChanged:(NSNotification*)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if(toBeString.length > 3) {
                textField.text = [toBeString substringToIndex:3];
            }
            
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况：emoji表情、en-US
    else{
        if (toBeString.length > 3) {
            textField.text= [toBeString substringToIndex:3];
        }
    }
    
}

- (void)setUI
{
    self.colorLabel.text = LocalizedString(@"color");
    self.brightnessLabel.text = LocalizedString(@"luminance");
    self.colorLabel.textColor = Theme.C4;
    self.brightnessLabel.textColor = Theme.C4;
    
    [self.sendColorBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    [self.sendBrightnessBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    
    self.sendColorBtn.backgroundColor = [Theme C2];
    self.sendBrightnessBtn.backgroundColor = [Theme C2];
    
    self.sendColorBtn.layer.masksToBounds = YES;
    self.sendColorBtn.layer.cornerRadius = 5;
    self.sendBrightnessBtn.layer.masksToBounds = YES;
    self.sendBrightnessBtn.layer.cornerRadius = 5;
    
    
    self.colorRTextField.text = [NSString stringWithFormat:@"%d", self.r];
    self.colorGTextfFiled.text = [NSString stringWithFormat:@"%d", self.g];
    self.colorBTextFiled.text = [NSString stringWithFormat:@"%d", self.b];
    self.colorWTextFiled.text = [NSString stringWithFormat:@"%d", self.w];
    self.brightnessTextFiled.text = [NSString stringWithFormat:@"%d", self.brightness];
    
    if (self.r == 0 && self.g == 0 && self.b == 0 && self.w == 0) {
        self.colorRTextField.text = @"";
        self.colorGTextfFiled.text = @"";
        self.colorBTextFiled.text = @"";
        self.colorWTextFiled.text = @"";
    }
    
    if (self.brightness == 0) {
        self.brightnessTextFiled.text = @"";
    }
}



- (IBAction)sendColorAction:(UIButton *)sender {
    
    BOOL valueR = self.colorRTextField.text.length;
    BOOL valueG = self.colorGTextfFiled.text.length;
    BOOL valueB = self.colorBTextFiled.text.length;
    BOOL valueW = self.colorWTextFiled.text.length;
    if (valueR && valueB && valueG && valueW) {
        
        int r = [self.colorRTextField.text intValue];
        int g = [self.colorGTextfFiled.text intValue];
        int b = [self.colorBTextFiled.text intValue];
        int w = [self.colorWTextFiled.text intValue];
        
        BOOL rValid = (r >= 0) && (r <= 255);
        BOOL gValid = (g >= 0) && (g <= 255);
        BOOL bValid = (b >= 0) && (b <= 255);
        BOOL wValid = (w >= 0) && (w <= 255);
        
        if (!(rValid && gValid && bValid && wValid)) {
            [Utils showMessage:LocalizedString(@"input_0_255") controller:self];
            return;
        }
        
        
        int brightness = [self.brightnessTextFiled.text intValue];
        
        if (!self.brightnessTextFiled.text.length) {
            brightness = 50;
        }
        
        BOOL brightValid = (brightness >= 0) && (brightness <= 100);
        if (!brightValid) {
            brightness = 50;
        }
        
        SLPLight *ligtht = [[SLPLight alloc] init];
        ligtht.r = r;
        ligtht.g = g;
        ligtht.b = b;
        ligtht.w = w;
        
        if (![SLPBLESharedManager blueToothIsOpen]) {
            [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
            return;
        }
        __weak typeof(self) weakSelf = self;
        
        [SLPBLESharedManager bleNox:SharedDataManager.peripheral turnOnColorLight:ligtht brightness:brightness timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
                return;
            }
            
            if ([weakSelf.delegate respondsToSelector:@selector(colorChangedWithR:g:b:w:brightness:)]) {
                [self.delegate colorChangedWithR:r g:g b:b w:w brightness:brightness];
            }
        }];
        //        [SLPBLESharedManager SAB:SharedDataManager.peripheral turnOnColorLight:ligtht brightness:brightness timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        //            if (status != SLPDataTransferStatus_Succeed) {
        //                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        //            }
        //        }];
    }else{
        [Utils showMessage:LocalizedString(@"input_0_255") controller:self];
    }
}

- (IBAction)sendBrightnessAction:(UIButton *)sender {
    if (!self.brightnessTextFiled.text.length) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    
    int brightness = [self.brightnessTextFiled.text intValue];
    BOOL brightValid = (brightness >= 0) && (brightness <= 100);
    if (!brightValid) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral lightBrightness:brightness timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(brightnessChanged:)]) {
            [self.delegate brightnessChanged:brightness];
        }
    }];
    //    [SLPBLESharedManager SAB:SharedDataManager.peripheral lightBrightness:brightness timeout:0 callback:^(SLPDataTransferStatus status, id data) {
    //        if (status != SLPDataTransferStatus_Succeed) {
    //            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
    //        }
    //    }];
}
@end
