//
//  KYLCameraMonitor.h
//  P2PCamera
//
//
//



#import <UIKit/UIKit.h>

#import "KYLMontiorTouchProtocol.h"
#import "KYLCamera.h"
#import "KYLImageProtocol.h"

#import "KYLImageProtocol.h"

@interface KYLCameraMonitor : UIImageView<UIScrollViewDelegate,KYLImageProtocol>
{
    id<KYLMontiorTouchProtocol> delegate;
    CGPoint gestureStartPoint;
    CGPoint initFontSize;
    NSInteger minGestureLength;
    NSInteger maxVariance;
    UIButton *btnStart;
    UILabel *lableCameraName;
    UIImageView *m_pImageView;
    BOOL m_bIsVideoPlaying;
    UIButton *btnRightBig;
    //MyGLViewController *myGLViewController;
    int m_iIndex;//记录在设备列表中的位置，第几行
    
    int m_nAudioStatusWhenLeaveFullScreen;
    int m_nTalkStatusWhenLeaveFulllScreen;
    int m_nChannel;
}

@property (nonatomic, assign) IBOutlet id<KYLMontiorTouchProtocol> delegate;
@property (nonatomic, retain) KYLCamera *m_pCameraObj;
@property (nonatomic, retain) UIButton *btnStart;
@property (nonatomic, retain) UIButton *btnRightBig;
@property (nonatomic, retain) UILabel *lableCameraName;
@property (nonatomic, retain) UIImageView *m_pImageView;
//@property (nonatomic, retain) MyGLViewController *myGLViewController;
@property (nonatomic, assign) int m_iIndex;//记录在设备列表中的位置，第几行
@property (nonatomic, assign) int m_nAudioStatusWhenLeaveFullScreen;
@property (nonatomic, assign) int m_nTalkStatusWhenLeaveFulllScreen;


- (void)setMinimumGestureLength:(NSInteger)length MaximumVariance:(NSInteger)variance;
- (int) startVideo;
- (int) stopVideo;
- (void) initTheBordColor;
- (void) clearTheBordColor;
- (void) changeBordColorToChoosedColor;
- (void) showTheRightButton:(BOOL) bShow;
- (void) refreshTheFrame:(CGRect) frame;
- (void) setPlay:(BOOL) bPlay;
- (BOOL) isCreateGLView;
- (void) showTheVideoStopedBgImage:(BOOL) bShow;
- (BOOL) isSelected;
- (void) initTheDisplayView;





@end
