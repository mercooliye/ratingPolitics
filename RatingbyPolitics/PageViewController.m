//
//  PageViewController.m
//  RatingbyPolitics
//
//  Created by CooLX on 20/04/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "PageViewController.h"
#import "mercoolViewController.h"
#import "MySingleton.h"

@interface PageViewController ()

@end

@implementation PageViewController
@synthesize logo;
@synthesize textview;
@synthesize progress;
NSConnection *conndescr;
NSMutableData *descrdata;
NSString *ID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    textview.editable=NO;
    self.logo.layer.cornerRadius=64;
    self.logo.layer.masksToBounds=YES;
    ID=[MySingleton sharedMySingleton].ID;
    textview.text=@"";
    [progress startAnimating];
    
  //  mercoolViewController *mview=[[mercoolViewController alloc] init];
    
    NSMutableArray *images=[MySingleton sharedMySingleton].images;
    NSInteger *index=[MySingleton sharedMySingleton].index.row;
    
    logo.image=[UIImage imageWithData:[images objectAtIndex:index]];

    NSString *urlHere = [NSString stringWithFormat:@"http://politics.mercool.tmweb.ru/getdescription.php?key=mercool2002&id=%@", ID] ;
    NSURLRequest *reqHere = [NSURLRequest requestWithURL:[NSURL URLWithString:urlHere]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    conndescr = [[NSURLConnection alloc] initWithRequest:reqHere delegate:self];
    descrdata=[NSMutableData data];

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // добавляем новые данные
    if(connection==conndescr)
    {
        [descrdata appendData:data];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conect
{
    if(conect==conndescr)
    {
        [progress stopAnimating];
        NSDictionary *dict_here = [NSJSONSerialization JSONObjectWithData:descrdata options:kNilOptions error:nil];
        
        NSDictionary *responce=[dict_here valueForKey:@"response"];
        NSString *descr=[[responce valueForKey:@"Description"] objectAtIndex:0];
        textview.text=descr;
        
     
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)news:(id)sender {
    
   
    //NSString *urlst=[NSString stringWithFormat:@"http://apple.com"];

    
    NSString *urlst=[NSString stringWithFormat:@"https://google.ru/search?", [MySingleton sharedMySingleton].name];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlst]];
    
}

@end
