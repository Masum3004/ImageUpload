//
//  ViewController.m
//  image upload using ftp server
//
//  Created by Kamalesh Babu Jayaraman on 26/07/13.
//  Copyright (c) 2013 Kamalesh Babu Jayaraman. All rights reserved.
//

#import "ViewController.h"
#import <CFNetwork/CFNetwork.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WhiteRaccoon.h"

@interface ViewController ()
{
    UIImage *image1 ;
}
@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //   uint8_t                     _buffer[kSendBufferSize];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
             galleryImage.image=[UIImage imageNamed:@"default.jpg"];
           }
    return self;
}
#pragma mark - developer methods
- (IBAction)openGallery {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Camera", @"Photo Gallery", nil];
        [actionSheet setTag:100];
        [actionSheet showInView:[self view]];
        
    } else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet tag] == 100) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if(buttonIndex == 0) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        
        [imagePickerController setDelegate:self];
         [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    galleryImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
   
    NSLog(@"--->> %@",info[@"UIImagePickerControllerReferenceURL"]);
    NSData *webData = UIImagePNGRepresentation(galleryImage.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:@"abcd.png"];
    [webData writeToFile:localFilePath atomically:YES];
    NSLog(@"localFilePath.%@",localFilePath);
    fullPath = localFilePath;
  image1 = [UIImage imageWithContentsOfFile:localFilePath];

}

-(IBAction)sendImage:(id)sender
{
    //ftp://DomainUrl/AddressPath
       //192.168.1.131
    SCRFTPRequest *ftpRequest = [SCRFTPRequest requestWithURL:[NSURL URLWithString:@"ftp://192.168.1.131"] toUploadFile:fullPath];
    
    ftpRequest.username = @"test";
    ftpRequest.password = @"test";
    //ftpRequest.customUploadFileName = @"ConductCare3.png";
    ftpRequest.delegate = self;
    [ftpRequest startAsynchronous];
    
}
- (void)ftpRequestWillStart:(SCRFTPRequest *)request

{
    
    NSLog(@"started");
    
}

- (void)ftpRequest:(SCRFTPRequest *)request didChangeStatus:(SCRFTPRequestStatus)status

{
    
    NSLog(@"didChanged");
    
}

- (void)ftpRequest:(SCRFTPRequest *)request didWriteBytes:(NSUInteger)bytesWritten

{
    
    NSLog(@"didWrited");
    
}
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request

{
    NSLog(@"Finished");
    
}

- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error

{
    
    NSLog(@"error %@",error);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnUploadABC:(id)sender {
    [self.myImageView setImage:image1];

}

-(void) requestCompleted:(WRRequest *) request{
    
    //called if 'request' is completed successfully
    NSLog(@"%@ completed!", request);
    
}

-(void) requestFailed:(WRRequest *) request{
    
    //called after 'request' ends in error
    //we can print the error message
    NSLog(@"req failed%@", request.error.message);
    
}

-(BOOL) shouldOverwriteFileWithRequest:(WRRequest *)request {
    NSLog(@"----------");
    //if the file (ftp://xxx.xxx.xxx.xxx/space.jpg) is already on the FTP server,the delegate is asked if the file should be overwritten
    //'request' is the request that intended to create the file
    return YES;
    
}

@end
