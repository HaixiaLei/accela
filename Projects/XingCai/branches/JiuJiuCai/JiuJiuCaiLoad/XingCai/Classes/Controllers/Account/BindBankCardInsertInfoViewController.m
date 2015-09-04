//
//  BindBankCardInsertInfoViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindBankCardInsertInfoViewController.h"
#import "BindBankCardConfirmViewController.h"
#import "UIUtil.h"
#import "BankListObject.h"
#import "ProvinceListObject.h"
#import "CityListObject.h"

@interface BindBankCardInsertInfoViewController()
@end

@implementation BindBankCardInsertInfoViewController
{
    BOOL isNeedHideMenu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //DLog(@"------------------u_Check----------------------%@", u_Check);
    //DLog(@"------------------u_CheckBank------------------%@", u_CheckBank);
    
    self.branchNameTxt.delegate = self;
    self.accountNameTxt.delegate = self;
    self.accountNoTxt.delegate = self;
    self.accountNoConfirmTxt.delegate = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideMenuController) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
    bankListArr = [[NSMutableArray alloc] init];
    provinceListArr = [[NSMutableArray alloc] init];
    [self getBankAndProvince];
    
    cityListArr = [[NSMutableArray alloc] init];
}
-(void)hideMenuController
{
    if ([UIMenuController sharedMenuController].menuVisible && isNeedHideMenu)
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ((textField == self.accountNoTxt) || textField == self.accountNoConfirmTxt)
    {
        isNeedHideMenu = YES;
    }
    else
    {
        isNeedHideMenu = NO;
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    //银行下拉初始值
    [self.blp setDates:bankNameArr];
    [self.blp reloadAllComponents];
    if ([self.bankListLab.text isEqualToString:@""])
    {
        bankIndex = 0;
        self.bankListLab.text = [bankNameArr objectAtIndex:0];
    }
    //省份下拉初始值
    [self.plp setDates:provinceNameArr];
    [self.plp reloadAllComponents];
    if ([self.provinceListLab.text isEqualToString:@""])
    {
        provinceIndex = 0;
        self.provinceListLab.text = [provinceNameArr objectAtIndex:0];
        
        //获取省份的id&名字，往后传，取城市
        ProvinceListObject *provinceListObj = [provinceListArr objectAtIndex:0];
        NSString *provinceId = [provinceListObj idd];
        NSString *provinceName = self.provinceListLab.text;
        NSString *provinceParameter = [[provinceId stringByAppendingString:@"#"] stringByAppendingString:provinceName];
        [self getCitys:provinceParameter];
    }
}
-(void) viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) getBankAndProvince
{
    [[AppHttpManager sharedManager] provinceListWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 //处理银行信息-------------------------------------------------------------------------------------begin
                 NSArray *itemArray = [JSON objectForKey:@"banklist"];
                 [bankListArr removeAllObjects];
                 for (int i = 0; i < itemArray.count; i++)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         BankListObject *bankListObj = [[BankListObject alloc] initWithAttribute:oneObjectDict];
                         [bankListArr addObject:bankListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 //获取银行名称
                 bankNameArr = [[NSMutableArray alloc] init];
                 [bankNameArr removeAllObjects];
                 for (int i = 0; i < bankListArr.count; i++)
                 {
                     BankListObject *bankListObj = [bankListArr objectAtIndex:i];
                     [bankNameArr addObject:[bankListObj bank_name]];
                 }
                 //处理银行信息---------------------------------------------------------------------------------------end
                 
                 //处理省份信息-------------------------------------------------------------------------------------begin
                 NSArray *provinceItemArray = [JSON objectForKey:@"provincelist"];
                 [provinceListArr removeAllObjects];
                 for (int i = 0; i < provinceItemArray.count; i++)
                 {
                     id oneObject = [provinceItemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         ProvinceListObject *provinceListObj = [[ProvinceListObject alloc] initWithAttribute:oneObjectDict];
                         [provinceListArr addObject:provinceListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 //获取省份名称
                 provinceNameArr = [[NSMutableArray alloc] init];
                 [provinceNameArr removeAllObjects];
                 for (int i = 0; i < provinceListArr.count; i++)
                 {
                     ProvinceListObject *provinceListObj = [provinceListArr objectAtIndex:i];
                     [provinceNameArr addObject:[provinceListObj name]];
                 }
                 //处理省份信息---------------------------------------------------------------------------------------end
             }
             else
             {
                 DDLogWarn(@"JSON should be NSString,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}

//选择银行------------------------------------------------------------------------begin
-(IBAction)bankListClk:(id)sender
{
    self.bankListView.hidden = NO;
}
- (void)bankListPicker:(BankListPicker *)picker didSelectDateWithName:(NSString *)name
{
    bankIndex = picker.selectRowNo;
    bankListText = name;
}
-(IBAction)bankCancelClk:(id)sender
{
    self.bankListView.hidden = YES;
}
-(IBAction)bankOKClk:(id)sender
{
    self.bankListView.hidden = YES;
    if (bankListText == nil)
    {
        self.bankListLab.text = [bankNameArr objectAtIndex:0];
    }
    else
    {
        self.bankListLab.text = bankListText;
    }
}
//选择银行--------------------------------------------------------------------------end

//选择省份------------------------------------------------------------------------begin
-(IBAction)provinceListClk:(id)sender
{
    self.provinceListView.hidden = NO;
}
- (void)provinceListPicker:(ProvinceListPicker *)picker didSelectDateWithName:(NSString *)name
{
    provinceIndex = picker.selectRowNo;
    provinceListText = name;
}
-(IBAction)provinceCancelClk:(id)sender
{
    self.provinceListView.hidden = YES;
}
-(IBAction)provinceOKClk:(id)sender
{
    self.provinceListView.hidden = YES;
    if (provinceListText == nil)
    {
        self.provinceListLab.text = [provinceNameArr objectAtIndex:0];
    }
    else
    {
        self.provinceListLab.text = provinceListText;
    }
    //获取省份的id&名字，往后传，取城市
    ProvinceListObject *provinceListObj = [provinceListArr objectAtIndex:provinceIndex];
    NSString *provinceId = [provinceListObj idd];
    NSString *provinceName = self.provinceListLab.text;
    NSString *provinceParameter = [[provinceId stringByAppendingString:@"#"] stringByAppendingString:provinceName];
    [self getCitys:provinceParameter];
}

- (void)getCitys:(NSString *)provinceInfo
{
    [[AppHttpManager sharedManager] cityListWithProvince:provinceInfo block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 //处理城市信息-------------------------------------------------------------------------------------begin
                 NSArray *itemArray = [JSON objectForKey:@"citys"];
                 [cityListArr removeAllObjects];
                 for (int i = 0; i < itemArray.count; i++)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         CityListObject *cityListObj = [[CityListObject alloc] initWithAttribute:oneObjectDict];
                         [cityListArr addObject:cityListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 //获取城市名称
                 cityNameArr = [[NSMutableArray alloc] init];
                 [cityNameArr removeAllObjects];
                 for (int i = 0; i < cityListArr.count; i++)
                 {
                     CityListObject *cityListObj = [cityListArr objectAtIndex:i];
                     [cityNameArr addObject:[cityListObj name]];
                 }
                 //处理城市信息---------------------------------------------------------------------------------------end
                 
                 //城市下拉初始值
                 [self.clp setDates:cityNameArr];
                 [self.clp reloadAllComponents];
                 self.cityListLab.text = [cityNameArr objectAtIndex:0];
                 cityIndex = 0;
             }
             else
             {
                 DDLogWarn(@"JSON should be NSString,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
         
     }];
}
//选择省份--------------------------------------------------------------------------end

//选择城市------------------------------------------------------------------------begin
-(IBAction)cityListClk:(id)sender
{
    self.cityListView.hidden = NO;
}
- (void)cityListPicker:(CityListPicker *)picker didSelectDateWithName:(NSString *)name
{
    cityIndex = picker.selectRowNo;
    cityListText = name;
}
-(IBAction)cityCancelClk:(id)sender
{
    self.cityListView.hidden = YES;
}
-(IBAction)cityOKClk:(id)sender
{
    self.cityListView.hidden = YES;
    if (cityListText == nil)
    {
        self.cityListLab.text = [cityNameArr objectAtIndex:0];
    }
    else
    {
        self.cityListLab.text = cityListText;
    }
}
//选择城市--------------------------------------------------------------------------end

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"Keyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.point = CGPointMake(0, 0);
    [UIView commitAnimations];
    
    [self.branchNameTxt resignFirstResponder];
    [self.accountNameTxt resignFirstResponder];
    [self.accountNoTxt resignFirstResponder];
    [self.accountNoConfirmTxt resignFirstResponder];
}

//当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"Keyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.point = CGPointMake(self.view.frame.origin.x,(IS_IPHONE5?-24:-112));
    [UIView commitAnimations];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.branchNameTxt)
    {
        [self.accountNameTxt becomeFirstResponder];
    }
    if (textField == self.accountNameTxt)
    {
        [self.accountNoTxt becomeFirstResponder];
    }
    return true;
}

//绑定银行卡-输入银行相关信息--------------------------------------------------------begin
//支行名称不能有特殊字符
-(BOOL)isIncludeSpecialCharact: (NSString *)str
{
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'!@#$%^&*()_+'\""]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
-(IBAction)bindBankCardConfirmInfoVC:(id)sender
{
    BOOL result = [self isIncludeSpecialCharact:self.branchNameTxt.text];
    
    //支行名称不能为空
    if ([self.branchNameTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"支行名称不能为空!"];
        return;
    }
    else
    {
        if (result == YES)
        {
            [Utility showErrorWithMessage:@"支行名称不能使用特殊字符!"];
            return;
        }
    }
    
    //开户人姓名不能为空
    if ([self.accountNameTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"开户人姓名不能为空!"];
        return;
    }
    //银行卡号不能为空
    if ([self.accountNoTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"银行卡号不能为空!"];
        return;
    }
    //银行卡号位数必须为16-19位
    if (self.accountNoTxt.text.length != 16 && self.accountNoTxt.text.length != 19)
    {
        [Utility showErrorWithMessage:@"银行卡号输入有误!"];
        return;
    }
    //确认卡号不能为空
    if ([self.accountNoConfirmTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"确认卡号不能为空!"];
        return;
    }
    //银行卡号,二者必须一致
    if (![self.accountNoTxt.text isEqualToString:self.accountNoConfirmTxt.text])
    {
        [Utility showErrorWithMessage:@"银行卡号前后输入不一致,请重新输入!"];
        return;
    }
    
    //Bank信息
    BankListObject *bankListObj = [bankListArr objectAtIndex:bankIndex];
    NSString *bankInfo = [[[bankListObj bank_id] stringByAppendingString:@"#"] stringByAppendingString:self.bankListLab.text];
    //Province信息
    ProvinceListObject *provinceListObj = [provinceListArr objectAtIndex:provinceIndex];
    NSString *provinceInfo = [[[provinceListObj idd] stringByAppendingString:@"#"] stringByAppendingString:self.provinceListLab.text];
    //City信息
    CityListObject *cityListObj = [cityListArr objectAtIndex:cityIndex];
    NSString *cityInfo = [[[cityListObj idd] stringByAppendingString:@"#"] stringByAppendingString:self.cityListLab.text];
    
    [[AppHttpManager sharedManager] addBankCardWithBankUniqueCode:bankInfo province:provinceInfo cityUniqueCode:cityInfo branch:self.branchNameTxt.text accountName:self.accountNameTxt.text account:self.accountNoTxt.text checkCode:u_Check bankCheckCode:u_CheckBank block:^(id JSON, NSError *error)
    {
        if (!error)
        {
            u_bank = [JSON objectForKey:@"bank"];
            u_bank_id = [JSON objectForKey:@"bank_id"];
            u_province = [JSON objectForKey:@"province"];
            u_province_id = [JSON objectForKey:@"province_id"];
            u_city_id = [JSON objectForKey:@"city_id"];
            u_city = [JSON objectForKey:@"city"];
            u_branch = [JSON objectForKey:@"branch"];
            u_account_name = [JSON objectForKey:@"account_name"];
            u_account = [JSON objectForKey:@"account"];
            u_add_bank_code = [JSON objectForKey:@"add_bank_code"];
            
            BindBankCardConfirmViewController *bbccVC = [[BindBankCardConfirmViewController alloc] initWithNibName:@"BindBankCardConfirmViewController" bundle:nil];
            [self.navigationController pushViewController:bbccVC animated:YES];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
    }];
}
//绑定银行卡-输入银行相关信息----------------------------------------------------------end
@end
