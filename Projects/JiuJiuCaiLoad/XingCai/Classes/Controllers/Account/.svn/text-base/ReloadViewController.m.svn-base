//
//  ReloadViewController.m
//  JiuJiuCai
//
//  Created by hadis on 15-4-10.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "ReloadViewController.h"
#import "ReloadDetailViewController.h"
#import "BindBankCardViewController.h"
#import "GoBindBankcardViewController.h"
@interface ReloadViewController ()

@end

@implementation ReloadViewController
{

    NSArray *bankimgAarray;
    NSString *bankName;
    NSMutableArray *bindArray;
    
    BOOL judgentBindCard;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.banklistArray =[NSArray array];
    bindArray=[NSMutableArray array];
//    NSArray *array =[[NSArray alloc]initWithObjects:@"abc",@"ccb",@"cmb",@"icbc", nil];
//    
//    for (NSString *string in array) {
//        
//        if ([string isEqualToString:@"abc"]) {
//            
//        }
//        }
  
    [[AppHttpManager sharedManager] bankListWithBlock:^(id JSON, NSError *error) {
        if (!error) {
            if ([JSON isKindOfClass:[NSArray class]]) {
                NSArray *array =JSON;
                if (array.count>0) {
                    self.banklistArray=array;
                     [self showBankCardlist];
                }
            }
        }
    }];

   
   


}
-(void)showBankCardlist
{

    if (self.banklistArray.count>0) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        
        for (int i=0; i<self.banklistArray.count; i++) {
            
            NSDictionary *bankdic = [self.banklistArray objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame =CGRectMake(0, 100+i*50, 320, 50);
            btn.tag=i;
            [self.view addSubview:btn];
            
            [btn addTarget:self action:@selector(chooseBank:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(150, 25, 160, 25)];
            [btn addSubview:label];
            label.textColor =[UIColor redColor];
            [label setFont:[UIFont systemFontOfSize:12]];
            [label setText:@"对不起,该充值渠道暂时关闭。"];
            label.hidden = YES;
            
            NSString *string_avalible = [numberFormatter stringFromNumber:[bankdic objectForKey:@"avalible"]];
            
            
            NSString *string_message = [bankdic objectForKey:@"msg"];
            
            NSString *string_bind = [numberFormatter stringFromNumber:[bankdic objectForKey:@"bind"]];
            
            if ([string_bind isEqualToString:@"1"]) {
                judgentBindCard=YES;
            }
            
            
            
            if ([[bankdic objectForKey:@"bank"]isEqualToString:@"abc"]) {
                
                UIImageView *btnbackimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
                [btnbackimg setImage:[UIImage imageNamed:@"charge_normal"]];
                UIImageView*bankicon  =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 129, 25)];
                [bankicon setImage:[UIImage imageNamed:@"bnt_ny"]];
                [btnbackimg addSubview:bankicon];
                
                UIImageView*arrowimg  =[[UIImageView alloc]initWithFrame:CGRectMake(290, 17.5, 10, 15)];
                [arrowimg setImage:[UIImage imageNamed:@"icn_normal"]];
                [btnbackimg addSubview:arrowimg];
                
                [btn addSubview:btnbackimg];
                
                NSString *string_bind = [numberFormatter stringFromNumber:[bankdic objectForKey:@"bind"]];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:string_bind forKey:@"abc"];
                [bindArray addObject:dic];
                
                if ([string_avalible isEqualToString:@"0"]) {
                    btn.enabled=NO;
                    label.hidden = NO;
                }

            }else if([[bankdic objectForKey:@"bank"]isEqualToString:@"icbc"]){
                //                            [btn setTitle:@"中国工商银行" forState:UIControlStateNormal];
                UIImageView *btnbackimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
                [btnbackimg setImage:[UIImage imageNamed:@"charge_normal"]];
                UIImageView*bankicon  =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 129, 25)];
                [bankicon setImage:[UIImage imageNamed:@"btn_gs"]];
                [btnbackimg addSubview:bankicon];
                UIImageView*arrowimg  =[[UIImageView alloc]initWithFrame:CGRectMake(290, 17.5, 10, 15)];
                [arrowimg setImage:[UIImage imageNamed:@"icn_normal"]];
                [btnbackimg addSubview:arrowimg];
                
                [btn addSubview:btnbackimg];
                
                
                NSString *string_bind = [numberFormatter stringFromNumber:[bankdic objectForKey:@"bind"]];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:string_bind forKey:@"icbc"];
                [bindArray addObject:dic];
                if ([string_avalible isEqualToString:@"0"]) {
                    btn.enabled=NO;
                    label.hidden = NO;
                }
                
                
                
                
            }else if([[bankdic objectForKey:@"bank"]isEqualToString:@"cmb"]){
                
                UIImageView *btnbackimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
                [btnbackimg setImage:[UIImage imageNamed:@"charge_normal"]];
                UIImageView*bankicon  =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 129, 25)];
                [bankicon setImage:[UIImage imageNamed:@"btn_zs"]];
                [btnbackimg addSubview:bankicon];
                
                UIImageView*arrowimg  =[[UIImageView alloc]initWithFrame:CGRectMake(290, 17.5, 10, 15)];
                [arrowimg setImage:[UIImage imageNamed:@"icn_normal"]];
                [btnbackimg addSubview:arrowimg];
                
                [btn addSubview:btnbackimg];
                
                NSString *string_bind = [numberFormatter stringFromNumber:[bankdic objectForKey:@"bind"]];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:string_bind forKey:@"cmb"];
                [bindArray addObject:dic];
                if ([string_avalible isEqualToString:@"0"]) {
                    btn.enabled=NO;
                    label.hidden = NO;
                }
                
                
                
                
            }else if([[bankdic objectForKey:@"bank"]isEqualToString:@"ccb"]){
                
                UIImageView *btnbackimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
                [btnbackimg setImage:[UIImage imageNamed:@"charge_normal"]];
                UIImageView*bankicon  =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 129, 25)];
                [bankicon setImage:[UIImage imageNamed:@"btn_js"]];
                [btnbackimg addSubview:bankicon];
                
                UIImageView*arrowimg  =[[UIImageView alloc]initWithFrame:CGRectMake(290, 17.5, 10, 15)];
                [arrowimg setImage:[UIImage imageNamed:@"icn_normal"]];
                [btnbackimg addSubview:arrowimg];
                
                [btn addSubview:btnbackimg];
                
                
                NSString *string_bind = [numberFormatter stringFromNumber:[bankdic objectForKey:@"bind"]];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:string_bind forKey:@"ccb"];
                [bindArray addObject:dic];
                if ([string_avalible isEqualToString:@"0"]) {
                    btn.enabled=NO;
                    label.hidden = NO;
                }
            }
        }
    }

}
-(void)chooseBank:(UIButton*)button
{

    ReloadDetailViewController *reloadVC = [[ReloadDetailViewController alloc] init];
    GoBindBankcardViewController *goBV = [[GoBindBankcardViewController alloc]init];
    
    
        if (button.tag==0) {
            reloadVC.bankname=@"abc";
            NSDictionary *dic =[bindArray objectAtIndex:0];
            NSString *str =[dic objectForKey:@"abc"];
            if ([str isEqualToString:@"0"]) {
                [self.navigationController pushViewController:goBV animated:YES];
                
            }else if([str isEqualToString:@"1"])
            {
                [self.navigationController pushViewController:reloadVC animated:YES];

            }
        } else if (button.tag==1) {
            reloadVC.bankname=@"icbc";
            NSDictionary *dic =[bindArray objectAtIndex:1];
            NSString *str =[dic objectForKey:@"icbc"];
            if ([str isEqualToString:@"0"]) {
                [self.navigationController pushViewController:goBV animated:YES];
                
            }else if([str isEqualToString:@"1"])
            {
                [self.navigationController pushViewController:reloadVC animated:YES];
            }
        }
        else if (button.tag==2)
        {
            reloadVC.bankname=@"ccb";
            NSDictionary *dic =[bindArray objectAtIndex:2];
            NSString *str =[dic objectForKey:@"ccb"];
            NSLog(@"%@",str);
            if ([str isEqualToString:@"0"])
            {
                [self.navigationController pushViewController:goBV animated:YES];
            }
            else if([str isEqualToString:@"1"])
            {
                [self.navigationController pushViewController:reloadVC animated:YES];
            }
        }
        else if (button.tag==3)
        {
            reloadVC.bankname=@"cmb";
            NSDictionary *dic =[bindArray objectAtIndex:3];
            NSString *str =[dic objectForKey:@"cmb"];
            if ([str isEqualToString:@"0"])
            {
                [self.navigationController pushViewController:goBV animated:YES];
            }
            else if([str isEqualToString:@"1"])
            {
                [self.navigationController pushViewController:reloadVC animated:YES];
            }
        }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
