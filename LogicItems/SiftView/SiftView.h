

/**
 *  @author sixiaobo, 15-11-26 16:11:19
 *
 *  侧滑视图，可切换视图控制器
 *
 *  @param open
 *
 *  @return
 *
 *  @since v6.3.5
 */
#import <UIKit/UIKit.h>
#import "Header.h"

typedef void (^ScrollBlock)(BOOL open);

@interface SiftView : UIView


//可以在代码块里写入需要关闭和开启的操作
- (instancetype)initWithVc:(UIViewController *)vc scrollBlock:(ScrollBlock)scrollBlock;

- (instancetype)initWithRootVc:(UIViewController *)vc;

- (void)show;

- (void)hidden;

- (void)changeVcWithClassName:(NSString *)className;


@end
