//
//  SocialConfigs.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#ifndef SocialConfigs_h
#define SocialConfigs_h

//======================Customized Settings
#define SocialCommentedHeadCellSize 50
#define SocialCommentsPerPage 1
#define SocialActivityCommentCellClassName @"SocialActivityCommentCell"
#define SocialCommentDetailsHead @"SocialCommentDetailsHead"
#define SocialCommentDetailsHeadLinkedPage @"Four23BookDetails"
#define SocialPageConnectionDelegate @"SocialPageConnectionDelegate"
#define SocialRequestCommentInfoHead [SocialServerPath stringByAppendingString:@"ui/bookinfo.php"]
#define SocialServerPath @""

 

#define Social_P_Type @"type"
#define Social_P_Avatar @"avatar"
#define Social_P_Content @"content"
#define Social_P_NickName @"nickname"
#define Social_P_ToNickName @"tonickname"
#define Social_P_Sex @"sex"
#define Social_P_SubjectContent @"subjectcontent"
#define Social_P_Timestamp @"timestamp"
#define Social_P_UserId @"userid"
#define Social_P_Token @"token"
#define Social_P_ForumID @"forumid"
#define Social_P_SubjectID @"subjectid"
#define Social_P_Page @"page"
#define Social_P_Perpage @"perpage"
#define Social_P_ID @"id"
#define Social_P_CommentID @"commentid"
#define Social_P_StarCount @"starcount"
#define Social_P_ReplyCount @"replycount"
#define Social_P_StarUserIDs @"staruserids"
#define Social_P_Replies @"replies"

#define KeyOfCellIndexPath  @"cellindex"
#define KeyOfCellClickStatus @"cellstatus"
//=================================End
#define SocialCommentCellSpace 8
#define SocialCommentCellTimeHeight 20
#define SocialCommentCellFontSize 12

#define SocialAvatarSize 60
#define SocialAvatarSpace 10
#define SocialFontSizeBig 14
#define SocialFontSizeMiddle 12
#define SocialFontSize 10
#define SocialCellSectionHeight 30
#define SocialCommentPopupReply @"reply"
#define SocialCommentPopupReport @"report"
#define SocialCommentPopupCancle @"cancle"

#define RequestSocialComment [SocialServerPath stringByAppendingString:@"social/comment.php"]
#define RequestSocialUIHotComments [SocialServerPath stringByAppendingString:@"social/ui/hotcomments.php"]
#define RequestSocialUINormalComments [SocialServerPath stringByAppendingString:@"social/ui/normalcomments.php"]
#define RequestSocialUICommentInfo [SocialServerPath stringByAppendingString:@"social/ui/commentinfo.php"]
#define RequestSocialReply [SocialServerPath stringByAppendingString:@"social/reply.php"]
#define RequestSocialStar [SocialServerPath stringByAppendingString:@"social/star.php"]
#define RequestSocialReportComment [SocialServerPath stringByAppendingString:@"social/reportcomment.php"]
#define RequestSocialUIActivity [SocialServerPath stringByAppendingString:@"social/ui/activity.php"]
#define RequestSocialUIMessage [SocialServerPath stringByAppendingString:@"social/ui/message.php"]


#endif /* SocialConfigs_h */
