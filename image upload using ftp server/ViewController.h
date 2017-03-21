//
//  ViewController.h
//  image upload using ftp server
//
//  Created by Kamalesh Babu Jayaraman on 26/07/13.
//  Copyright (c) 2013 Kamalesh Babu Jayaraman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRFTPRequest.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,SCRFTPRequestDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIImageView  *galleryImage;
    IBOutlet UIButton *imgBtn;
    NSString * fullPath;
       }
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
-(IBAction)sendImage:(id)sender;
@end
