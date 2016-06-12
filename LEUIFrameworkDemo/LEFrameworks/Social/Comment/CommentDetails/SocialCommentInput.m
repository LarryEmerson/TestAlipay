//
//  SocialCommentInput.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/12.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "SocialCommentInput.h"
@interface SocialCommentInput()<UITextViewDelegate>
@end
@implementation SocialCommentInput{
    LEUIFramework *globalVar;
    UIView *curInputBG;
    UITextView *curInput;
    //
    NSString *finalInput;
}

//
-(id) initWithDelegate:(id) delegate{
    self.delegate = delegate;
    globalVar=[LEUIFramework instance];
    self=[super initWithFrame:CGRectMake(0, 0,globalVar.ScreenWidth, globalVar.ScreenHeight)];
    [self setBackgroundColor:ColorMask8];
    [self initUI];
    [self easeIn];
    return self;
}


-(void) easeIn{
    [self setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^(void){
        [self setAlpha:1];
    } completion:^(BOOL isDone){
        [curInput becomeFirstResponder];
    }];
}

-(void) easeOut{
    [curInput resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationCurveLinear animations:^(void){
        [self setAlpha:0];
    } completion:^(BOOL isDone){
        if(self.delegate && [self.delegate respondsToSelector:@selector(onDoneInputWith:)]){
            [self.delegate onDoneInputWith:finalInput];
        }
        [self removeFromSuperview];
    }];
}
//
-(void) initUI{
    UIView *v=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:v];
    [self addTapEventWithSEL:@selector(onCancle)];
    //
    UIImage *imgBg=[UIImage imageNamed:@"SocialPopupBackground"];
    int space=18;
    curInputBG=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomCenter Offset:CGPointZero CGSize:CGSizeMake(globalVar.ScreenWidth,globalVar.ScreenWidth/2)]];
    [curInputBG setBackgroundColor:[UIColor colorWithRed:0.890 green:0.906 blue:0.933 alpha:1.000]];
    [curInputBG setUserInteractionEnabled:YES];
    //
    [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curInputBG Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, space/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"写书评" FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:[[UIColor alloc] initWithRed:0.757 green:0.255 blue:0.302 alpha:1.000] Line:1 Alignment:NSTextAlignmentCenter]];
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curInputBG Anchor:LEAnchorInsideTopLeft Offset:CGPointZero CGSize:CGSizeMake(space*4, space*2)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"取消" FontSize:SocialFontSizeBig Font:nil Image:nil BackgroundImage:nil Color:ColorBlack SelectedColor:ColorGrayText MaxWidth:0 SEL:@selector(onCancle) Target:self]];
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curInputBG Anchor:LEAnchorInsideTopRight Offset:CGPointZero CGSize:CGSizeMake(space*4, space*2)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"发送" FontSize:SocialFontSizeBig Font:nil Image:nil BackgroundImage:nil Color:ColorBlack SelectedColor:ColorGrayText MaxWidth:0 SEL:@selector(onSend) Target:self]];
    //
    curInput=[[UITextView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curInputBG Anchor:LEAnchorInsideBottomCenter Offset:CGPointMake(0, -space) CGSize:CGSizeMake(globalVar.ScreenWidth-space*2, globalVar.ScreenWidth/2-space*3)]];
    [curInput setDelegate:self];
    [curInput setBackgroundColor:ColorWhite];
    [curInput setTextAlignment:NSTextAlignmentNatural];
    [curInput setFont:[UIFont systemFontOfSize:SocialFontSizeBig]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [curInputBG leSetOffset:CGPointMake(0, keyboardRect.origin.y-self.frame.size.height)];
//        self.frame = CGRectMake(self.frame.origin.x, keyboardRect.origin.y-self.frame.size.height,self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished){ }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [curInputBG leSetOffset:CGPointMake(0, keyboardRect.origin.y-self.frame.size.height)];
//        self.frame = CGRectMake(self.frame.origin.x, keyboardRect.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished){ }];
}

-(void) onCancle{
    finalInput=@"";
    [self easeOut];
}
-(void) onSend{
    finalInput=curInput.text;
    [self easeOut];
}
@end
