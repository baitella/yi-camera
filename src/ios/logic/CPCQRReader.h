#import <AVFoundation/AVFoundation.h>

typedef void (^QRReaderFailBlock)(void);
typedef void (^QRReaderSuccessBlock)(NSString *msg);

@interface CPCQRReader : NSObject <AVCaptureMetadataOutputObjectsDelegate> {
    dispatch_queue_t serialQueue;
}

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) UIView *uiView;
@property (nonatomic) UIView *eventTrap;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, copy) QRReaderFailBlock failBlock;
@property (nonatomic, copy) QRReaderSuccessBlock successBlock;

- (id)initWithView:(UIView *)view;

- (void)startReadingWithFailBlock:(QRReaderFailBlock)fBlock andSuccessBlock:(QRReaderSuccessBlock)sBlock;

- (BOOL)startReading;
-  (void)captureOutput:(AVCaptureOutput *)captureOutput
   didOutputMetadataObjects:(NSArray *)metadataObjects
        fromConnection:(AVCaptureConnection *)connection;
- (void)cleanup;
- (void)tapHandler:(UITapGestureRecognizer *)recognizer;

@end