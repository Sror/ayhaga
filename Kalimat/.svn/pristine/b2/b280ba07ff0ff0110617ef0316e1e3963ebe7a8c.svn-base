//
//  MyBooksCell.m
//  Kalimat
//
//  Created by Staff on 4/28/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import "MyBooksCell.h"
#import "BookCell.h"
#import "UserDefaults.h"
#import "EPubViewController.h"
#import "Constants.h" 
#import "UsageData.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 1
#define kAnimationTranslateY 1

@implementation MyBooksCell
@synthesize booksArray,horizontalTableView,viewController;


- (id)initWithIsLastCategory:(BOOL)isLastCategory
{
    if ((self = [super init]))
    {
        self.horizontalTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 235, 768)] autorelease];
        self.horizontalTableView.showsVerticalScrollIndicator = NO;
        self.horizontalTableView.showsHorizontalScrollIndicator = NO;
        self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        
        [self.horizontalTableView setFrame:CGRectMake(27, 0, 768, 235)];
        self.horizontalTableView.rowHeight = 152+32;
        
        self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.horizontalTableView.separatorColor = [UIColor clearColor];
        
        self.horizontalTableView.backgroundColor=[UIColor clearColor];
        self.horizontalTableView.dataSource = self;
        self.horizontalTableView.delegate = self;
        self.horizontalTableView.sectionHeaderHeight = 10 ;
        [self.horizontalTableView setContentInset:UIEdgeInsetsMake(5, 0, 0, 0)] ;
        [self addSubview:self.horizontalTableView];
        shaking = NO ; 
    }
    
    return self;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(IBAction)askForDeleteBook:(UISwipeGestureRecognizer *)sender{
    
    [self.delegate shakeCell];
    
    
}



-(void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate shakeCell];
    }
}


-(void)deleteButtonPressed:(UIButton *)sender
{
    
    BookCell *cell = (BookCell *)[[[sender superview] superview] superview];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"هل ترغب في حذف هذا الكتاب؟" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم",nil];
    NSIndexPath *indexPath = [self.horizontalTableView indexPathForCell:cell ];
   
    alertView.tag=indexPath.row;
    [alertView show];
    [alertView release];

   // 
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {

        int index = 3-alertView.tag ;

    
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"books/%@.epub",[self.booksArray objectAtIndex:index]]];
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"books/%@c.jpg",[self.booksArray objectAtIndex:index]]];
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"books/t%@.jpg",[self.booksArray objectAtIndex:index]]];
        [UserDefaults removeBookWithID:[self.booksArray objectAtIndex:index]];
        [UserDefaults addObject:nil withKey:[self.booksArray objectAtIndex:index] ifKeyNotExists:NO];
        
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"deletedBooks.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *deleteBookArray ;
        
        if (![fileManager fileExistsAtPath: path])
        {
            path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"deletedBooks.plist"] ];
            deleteBookArray = [[NSMutableArray alloc] init];
        }
        
        else
            deleteBookArray = [[NSMutableArray alloc] initWithContentsOfFile: path];
        //
        NSDictionary *deletedBook = [NSDictionary dictionaryWithObjectsAndKeys:[self.booksArray objectAtIndex:index],@"itemnumber",[NSDate date] ,@"time", nil];
        [deleteBookArray addObject:deletedBook];
        [deleteBookArray writeToFile:path atomically:YES];
        [deleteBookArray release];

        self.booksArray=[NSMutableArray arrayWithArray:[UserDefaults getArrayWithKey:DOWNLOADED_BOOKS]];
        
          [self.delegate deleteCell];
        //[self performSelector:@selector(shakeAnimation) withObject:nil afterDelay:0.05];

    }
    
}
-(void)shakeAnimation
{
    shaking = YES ;
    
    
    NSArray *cellArray =[self.horizontalTableView visibleCells] ;
    for(int i = 0 ; i < cellArray.count ; i++ )
    {
        BookCell *cell = [cellArray objectAtIndex:i];
   
        
        int count = 1;
        cell.deleteButton.hidden = NO ;
        [cell.deleteButton setSelected:NO]; 
        
        [cell bringSubviewToFront:cell.deleteButton];
        cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5 );
        
        CGAffineTransform leftWobble =  CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg * (count%2 ? 1 :-1 ) ));
        CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg * (count%2 ? -1 : 1 ) ));
        CGAffineTransform moveTransform =  CGAffineTransformTranslate(rightWobble, -kAnimationTranslateX, -kAnimationTranslateY);
        CGAffineTransform conCatTransform =  CGAffineTransformConcat(rightWobble,moveTransform);
        
        cell.cellView.transform = CGAffineTransformIdentity ;
        [cell.cellView.layer removeAllAnimations];
        cell.cellView.transform = leftWobble  ;
        
        
        
        [UIView animateWithDuration:0.13
                              delay:(count*i * 0.04)
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat |UIViewAnimationOptionAutoreverse
                         animations:^{
                             cell.cellView.transform = conCatTransform ;
                         }
                         completion:nil];
    }
}


-(void)stopShaking
{
    shaking = NO ; 
    NSArray *cellArray =[self.horizontalTableView visibleCells] ;

    for(int i = 0 ; i < cellArray.count ; i++ )
    {
        BookCell *cell = [cellArray objectAtIndex:i];
        [cell.cellView.layer removeAllAnimations];
        cell.cellView.transform = CGAffineTransformIdentity;
        cell.deleteButton.hidden = YES ;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.booksArray count]<4) {
        isLessThan4=YES;
        tableView.scrollEnabled=NO;
        return 4;
    }
    return [self.booksArray count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[BookCell alloc] init] autorelease];
        
           }

    if(4-indexPath.row <=[self.booksArray count])
    {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.downloadedImage.hidden=YES;
                cell.progressView.hidden=YES;
                cell.userInteractionEnabled=YES;
                cell.indicatorView.hidden=YES;
                NSData *thumbImg=[UserDefaults getDataWithName:[NSString stringWithFormat:@"t%@.jpg",[self.booksArray objectAtIndex:3-indexPath.row]] inRelativePath:@"/books" inDocument:YES ];
                if (thumbImg) {
                    [cell.thumbnail setImage:[UIImage imageWithData:thumbImg]];
                }
                
                [cell.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            });
        });
    
    }
    else
        cell.hidden=YES;
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(askForDeleteBook:)] autorelease];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(askForDeleteBook:)] autorelease];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    tapRecognizer.delegate = self;
    
    
    [cell addGestureRecognizer:rightSwipeRecognizer];
    [cell addGestureRecognizer:leftSwipeRecognizer];
    [cell addGestureRecognizer:tapRecognizer];

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(shaking)
    {
        shaking = NO ; 
        [self.delegate stopShake];
        return ; 
    }
    BookCell *cell = (BookCell *)[horizontalTableView cellForRowAtIndexPath:indexPath];
    [cell.deleteButton setSelected:NO]; 
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *currentBook=nil;
    
        currentBook = [self.booksArray objectAtIndex:3-indexPath.row];
      
        [NSThread detachNewThreadSelector:@selector(showIndicator) toTarget:self.viewController withObject:nil];
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:@"/books"];
        NSString *dataPath = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.epub",currentBook]];
        EPubViewController *ePubViewController=[[EPubViewController alloc] initWithUrl:[NSURL fileURLWithPath:dataPath] withID:currentBook];
        
      //  ePubViewController.bookId=currentBook;
        if([UsageData getiOSVersion] == 7)
        {
           self.viewController.hidesBottomBarWhenPushed = YES ;
           self.viewController.tabBarController.tabBar .hidden = YES ;
        }
        [self.viewController.navigationController pushViewController:ePubViewController animated:YES];
    [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self.viewController withObject:nil];
    [ePubViewController release];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
