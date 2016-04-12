//
//  PersonalTableViewController.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "SettingViewController.h"
#import "ActivityContanierViewController.h"

#import "UIImage+Compress.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Config.h"

@interface PersonalTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UIImagePickerController *_picker;
}
- (IBAction)loginBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = NO;
    [self initPickView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *token = [[Config Instance] getToken];
    if (token) {//登录状态
        self.loginBtn.hidden = YES;
        self.nameLabel.text = [NSString stringWithFormat:@"用户名:%@",[[Config Instance] getUserName]];
        NSString *iconUrl = [[Config Instance] getUserIcon];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"login_icon"]];
        self.iconImageView.layer.masksToBounds = YES;
    }else{
        self.loginBtn.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)initPickView{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
}
- (void)openCamera{
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_picker animated:YES completion:nil];
}
- (void)openPhotoAlbum{
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:nil];
}
#pragma mark-UINavigationControllerDelegate & UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //压缩图片尺寸
    UIImage *scaleImage = [image scaleToSize:CGSizeMake(57, 57)];
    [self fixOrientation:scaleImage];
    [self showHudInView:self.view hint:@"上传图片..."];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);  //创建一个信号
        NSData * data = UIImageJPEGRepresentation(scaleImage, 0.8);
        [[MyAPI sharedAPI] uploadImage:data result:^(BOOL sucess, NSString *msg) {
            //登录超时处理
            if ([msg isEqualToString:@"登录超时"]) {
                [self timeOutAction];
            }
            if (sucess) {//更新头像
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:msg] placeholderImage:[UIImage imageNamed:@"login_icon"]];
                [[Config Instance] saveIcon:msg];
            }
            [self hideHud];
            
        } errorResult:^(NSError *enginerError) {
            [self hideHud];
            
        }];
//        NSString *str =[NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
//        str = [str stringByAppendingString:@".png"];
//        [data writeToFile:[Tools documentPath:str] atomically:YES];
//        [[MyAPI sharedAPI] postFileAndImage:[Tools documentPath:str]
//                                       type:@"1"
//                                       name:str
//                                     result:^(BOOL success, NSString *msg, id object) {
//                                         if (success) {
//                                             [self hideHud];
//                                             
//                                             
//                                             
////                                             _headImageUrl = object[@"url"];
////                                             [[Config Instance] saveavatarURL:_headImageUrl];
//                                             dispatch_async(dispatch_get_main_queue(), ^{
////                                                 self.headerImageView.image = image;
//                                             });
//                                             dispatch_semaphore_signal(semaphore);     //发送一个信号
//                                         }else{
//                                             NSLog(@"%@",@"上传失败");
//                                         }
//                                     }];
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //等待信号 //下载结束后继续
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideHud];
//        });
//       // [self uploadHeadImage];
//    });
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!KToken) {//未登录状态不能查看资料
        return;
    }
    //修改头像
    if (indexPath.section == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册选取", nil];
        sheet.tag = 100;
        [sheet showInView:self.view];
    }
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {//点击资料
            [self performSegueWithIdentifier:@"userInfoSegue" sender:nil];
        }
        if (indexPath.row == 1) {   //点击我的老师
            [self performSegueWithIdentifier:@"AttentionTeacherListSegue" sender:nil];
        }else if (indexPath.row == 2){ //点击我的活动
         ActivityContanierViewController *activityVC = self.tabBarController.viewControllers[2];
           // activityVC.segmentedControl.selectedSegmentIndex = 0;
            self.tabBarController.selectedIndex = 2;
        }else if (indexPath.row == 3){ //点击我的消息
            [self performSegueWithIdentifier:@"NoticeListSegue" sender:nil];
        }
    }
    //点击设置
    if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"SettingSegue" sender:nil];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (IBAction)loginBtn:(UIButton *)sender {
    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//相机选取
        [self openCamera];
    }else if(buttonIndex == 1){//照片选取
        [self openPhotoAlbum];
    }else{
        return;
    }
}
- (void)fixOrientation:(UIImage *)aImage {
    if (aImage==nil || !aImage) {
        return;
    }
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation orientation=aImage.imageOrientation;
    int orientation_=orientation;
    switch (orientation_) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (orientation_) {
        case UIImageOrientationUpMirrored:{
            
        }
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    aImage=img;
    img=nil;
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
@end
