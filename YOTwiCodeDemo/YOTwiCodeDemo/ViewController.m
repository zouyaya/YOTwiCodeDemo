//
//  ViewController.m
//  YOTwiCodeDemo
//
//  Created by izaodao on 17/4/19.
//  Copyright © 2017年 izaodao. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer * layer;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *scamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scamButton.backgroundColor = [UIColor redColor];
    scamButton.frame = CGRectMake(70, 100, 200, 50);
    [scamButton setTitle:@"点击进行扫码" forState:UIControlStateNormal];
    [scamButton addTarget:self action:@selector(preeToScam:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scamButton];
    
    
    
   
}

-(void)preeToScam:(UIButton *)button{

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    session = [[AVCaptureSession alloc]init];
    
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    NSError *error = nil;
    if (input) {
        [session addInput:input];
        
    }else{
        NSLog(@"error----- %@",[error localizedDescription]);
    }

    
    AVCaptureMetadataOutput * outPut = [[AVCaptureMetadataOutput alloc]init];
    
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    outPut.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = CGRectMake(50, 150, 288, 100);
    [self.view.layer insertSublayer:layer atIndex:0];
    [session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    NSLog(@"来到了代理方法");
    NSString *scamCode = nil;
    for (AVMetadataObject *metaData in metadataObjects) {
        if ([metaData.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            scamCode = [(AVMetadataMachineReadableCodeObject *)metaData stringValue];
            break;
        }
        
    }

    [session stopRunning];

}

@end
