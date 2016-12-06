//
//  HomeTableViewController.m
//  vistorsSDK
//
//  Created by tanghy on 16/4/20.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "HomeTableViewController.h"
#import "chat_ViewController.h"
//#import "ConnBufferService.h"
#import "MessageManager.h"
#import "HttpService.h"
#import "Util.h"
@interface HomeTableViewController ()<UIAlertViewDelegate>


@end

@implementation HomeTableViewController{
    NSMutableArray *workList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    workList = [[NSMutableArray alloc]init];
    self.navigationItem.title =@"接待方式";
    self.tableView.tableFooterView = [[UIView alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(referList:) name:@"TNT" object:nil];
    
    

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (![Nationnal shareNationnal].token) {
        return;
    }
    
    [[IMSocket sharedObject] sendMessage:[MessageManager getBufTNTbody]];
//    [IMSocket sharedObject] sendMessage:[MessageManager getBufTNTbody]];
//    [[ConnBufferService connSocket]sendMessage:[MessageManager getBufTNTbody]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)referList:(NSNotification*)notify{
    NSString *str = notify.object;
    workList = [[Util StringOrDic2NSDic:str] objectForKey:@"kf-all-list"];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger num = [workList count];
    num =num==0?1:num+1;
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 56;
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
    bg.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screenWidth, 20)];
    if ([workList count]>0) {
        if (section==[workList count]) {
            lable.text = @"机器人";
        }else{
            lable.text = [Util stringByDecodingURLFormat:[workList[section] objectForKey:@"groupname"]] ;
        }
    }
    lable.font = [UIFont systemFontOfSize:12];
//    lable.backgroundColor  = [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1];
    [bg addSubview:lable];
    return bg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  20;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (section != workList.count) {
      num =  [[workList[section] objectForKey:@"workers"] count];
    }else{
        num= 1;
    }
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    if (indexPath.section != workList.count && workList.count>0) {
        NSDictionary *info = [[workList[indexPath.section] objectForKey:@"workers"] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"Shape"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[Util stringByDecodingURLFormat:[info objectForKey:@"nickname"]]];
        cell.detailTextLabel.text = [[info objectForKey:@"status"] intValue]==0?@"离线":@"在线";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"Shape"];
        cell.textLabel.text = @"机器人";
    }
   
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",[Util stringByDecodingURLFormat:[info objectForKey:@"nickname"]],[[info objectForKey:@"status"] intValue]==0?@"离线":@"在线"];
  

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![Nationnal shareNationnal].token) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"服务暂时出了点问题哦，请稍后再试！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    chat_ViewController *chat = [chat_ViewController alloc];

    
    if (indexPath.section != [workList count]) {
        NSDictionary *info = [[workList[indexPath.section] objectForKey:@"workers"] objectAtIndex:indexPath.row];
        chat.isRobot = NO;
        chat.myHead = [UIImage imageNamed:@"Shape"];
        chat.titleStr = [Util stringByDecodingURLFormat:[info objectForKey:@"nickname"]];
        if ([[info objectForKey:@"status"] intValue]==0) {//如果客服不在线不建立对话
            chat.isLeave = YES;
            //如果发送离线消息要先赋值客服id
            [Nationnal shareNationnal].kfid = [info objectForKey:@"id6d"];
            //        chat.isLeave = [info objectForKey:@"nickname"];
            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"客服不在线是否转机器人接待" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            //        [alert show];
            //        return;
        }else{//如果客服在线发起建立对话命令
//            如果groupid和id6d同时不传就为默认分配
            [[IMSocket sharedObject] sendMessage:[MessageManager getBufLNKbody:[Nationnal shareNationnal].company_id groupId:[workList[indexPath.section] objectForKey:@"groupId"]  id6d:[info objectForKey:@"id6d"]]];
//            [[ConnBufferService connSocket] sendMessage:[MessageManager getBufLNKbody:[Nationnal shareNationnal].company_id groupId:[workList[indexPath.section] objectForKey:@"groupId"]  id6d:[info objectForKey:@"id6d"]]];
//            [[ConnBufferService connSocket] sendMessage:[MessageManager getBufLNKbody:[Nationnal shareNationnal].company_id groupId:nil  id6d:nil]];
        }

    }else{
         chat.isRobot = YES;
    }
    
   
   
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",[info objectForKey:@"nickname"],[[info objectForKey:@"status"] intValue]==0?@"离线":@"在线"];
    
    
    
    
    [self.navigationController pushViewController:[chat init] animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        chat_ViewController *chat = [chat_ViewController alloc];
        chat.isRobot = YES;
        [self.navigationController pushViewController:[chat init] animated:YES];
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
