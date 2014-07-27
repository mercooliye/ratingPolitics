//
//  mercoolViewController.m
//  RatingbyPolitics
//
//  Created by CooLX on 19/04/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "mercoolViewController.h"
#import "MySingleton.h"


@interface mercoolViewController ()

@end

@implementation mercoolViewController
@synthesize table;
@synthesize images;
@synthesize images2;
@synthesize progress;
@synthesize responce;
@synthesize scroll;
@synthesize banner;

//@synthesize jsondata;
float i;
NSString *rattest;
NSURLConnection *conngetdada;
NSMutableData *multidata;
NSArray *name;
NSArray *post;
NSArray *age;
NSMutableArray *rating;
NSArray *description;
NSArray *photourl;
NSArray *Id;
NSMutableArray *status;
NSArray *gruppa;
NSArray *jsondata;




- (void)viewDidLoad
{
    
    [super viewDidLoad];
  
    self.bannerIsVisible=YES;
    
    //rating=[[NSMutableArray alloc] init];
    [progress startAnimating];
    NSString *urlHere = [NSString stringWithFormat:@"http://politics.mercool.tmweb.ru/getdata.php?key=mercool2002"] ;
    NSURLRequest *reqHere = [NSURLRequest requestWithURL:[NSURL URLWithString:urlHere]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [scroll setContentSize:CGSizeMake(500, 30)];
    [scroll setHidden:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    conngetdada = [[NSURLConnection alloc] initWithRequest:reqHere delegate:self];
    multidata=[NSMutableData data];
    
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // добавляем новые данные
    if(connection==conngetdada)
    {
        [multidata appendData:data];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conect
{
    if(conect==conngetdada)
    {
        jsondata = [NSJSONSerialization JSONObjectWithData:multidata options:kNilOptions error:nil];
        
        responce=[jsondata valueForKey:@"response"];
        name=[responce valueForKey:@"Name"];
        post=[responce valueForKey:@"Post"];
        age=[responce valueForKey:@"Age"];
        rating=[responce valueForKey:@"Rating"];
        description=[responce valueForKey:@"Description"];
        photourl=[responce valueForKey:@"PhotoURL"];
        Id=[responce valueForKeyPath:@"id"];
        status=[responce valueForKey:@"id"];
        gruppa=[responce valueForKey:@"Gruppa"];
        for (int i=0; i<status.count; i++)
        {
       [[[NSUserDefaults standardUserDefaults] valueForKey:@"Status" ]addObject:@"_" ];
        }
        NSArray *tempp=[[NSUserDefaults standardUserDefaults] valueForKey:@"Status" ] ;
        images=[[NSMutableArray alloc] init];
        for (int i=0; i<name.count	; i++)
        {
            
            
            
            NSString *img_url=[NSString stringWithFormat:@"%@",[photourl objectAtIndex:i]];
            
            NSURL *imageURL = [NSURL URLWithString:img_url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            [images addObject:imageData];
            images2=images;
          //  [images2 addObject:imageData];
            
            // [images addObject:[NSString stringWithFormat:@"%@",imageURL]];//работает!!!
            
            [progress stopAnimating];
        }
        
     
    
        //[ppSingleton sharedMySingleton].home=home;
        //[ppSingleton sharedMySingleton].street=street;
        
        
        [table reloadData];
        [scroll setHidden:NO];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return name.count;//[ppSingleton sharedMySingleton].venues_global.count;
    //venues_dist=[[ppSingleton sharedMySingleton].venues_global valueForKey:@"location"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cellPolitics *cell = [table dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.name.text = [name objectAtIndex:indexPath.row];
    cell.post.text = [post objectAtIndex:indexPath.row];
    cell.age.text=[age objectAtIndex:indexPath.row];
    cell.rating.text=[rating objectAtIndex:indexPath.row];
    if  ([[rating objectAtIndex:indexPath.row] floatValue]<0)
    {
        cell.rating.textColor=[UIColor redColor];
        
        cell.logo.layer.borderColor=[UIColor colorWithRed:220.0/255.0
                                                    green:0/0
                                                     blue:0/0
                                                    alpha:1.0].CGColor;

        
    }
    else
    {
    cell.rating.textColor=[UIColor greenColor];
        
        
        cell.logo.layer.borderColor=[UIColor colorWithRed:0/0
                                                    green:220.0/255.0
                                                     blue:0/0
                                                    alpha:1.0].CGColor;
    }
    
    cell.logo.layer.cornerRadius=32;
    cell.logo.layer.masksToBounds = YES;
    cell.logo.layer.borderWidth=2;
    
    
    cell.logo.image=[UIImage imageWithData:[images objectAtIndex:indexPath.row]];
 //
    cell.up.button_indexPath = indexPath; //присваиваем кнопке значение indexPath
    [cell.up addTarget:self action:@selector(ratingUp:) forControlEvents:UIControlEventTouchUpInside]; //устанавливаем обработчик для нажатия кнопки
    cell.down.button_indexPath = indexPath; //присваиваем кнопке значение indexPath
    [cell.down addTarget:self action:@selector(ratingDown:) forControlEvents:UIControlEventTouchUpInside]; //устанавливаем обработчик для нажатия кнопки
 //
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"page"]) {
       
        NSIndexPath *index_= [self.table indexPathForSelectedRow];
        [MySingleton sharedMySingleton].index=index_;
        [MySingleton sharedMySingleton].images=images;
        [MySingleton sharedMySingleton].ID=[Id objectAtIndex:index_.row];
        
        [MySingleton sharedMySingleton].name=[name objectAtIndex:index_.row];
    }
}


-(void) up:(NSString*)_id
{
    NSString *urlup = [NSString stringWithFormat:@"http://politics.mercool.tmweb.ru/up.php?key=mercool2002&id=%@", _id];
    NSURLRequest *requp = [NSURLRequest requestWithURL:[NSURL URLWithString:urlup]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSURLConnection *connup  = [[NSURLConnection alloc] initWithRequest:requp delegate:self];
    
}

-(void) down:(NSString*)_id
{
    NSString *urlup = [NSString stringWithFormat:@"http://politics.mercool.tmweb.ru/down.php?key=mercool2002&id=%@", _id] ;
    NSURLRequest *requp = [NSURLRequest requestWithURL:[NSURL URLWithString:urlup]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSURLConnection *conndown = [[NSURLConnection alloc] initWithRequest:requp delegate:self];
    
}

-(IBAction)ratingUp:(id)sender{
    
    
    NSIndexPath *path = [sender button_indexPath]; //извлекаем IndexPath с кнопки.
    NSInteger *index_=[[Id objectAtIndex:path.row] integerValue]-1;
    NSString *statusst=[[[NSUserDefaults standardUserDefaults] objectForKey: @"Status"] objectAtIndex:index_];
    
    if ([statusst isEqualToString:@"YES"])
    {
        UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Повторное голосование"
                                                              message:@"Вы уже голосовали ЗА!"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
       

        
        
        [simpleAlert show];
    
    }
    else {
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:rating];
    int ratf= [[rating objectAtIndex:path.row] intValue] ;
    ratf++;
    [tempArray replaceObjectAtIndex:path.row withObject:[NSString stringWithFormat:@"%d", ratf] ];
    rating=tempArray;
   
    [self up:[Id objectAtIndex:path.row]];// вызов в базу плюс рейтинг
    
    UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Рейтиг Политиков"
                                                          message:@"Ваш голос ЗА учтен!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [simpleAlert show];
  
    [table reloadData];
////// cистема контроля
    NSMutableArray *tempStatus=[NSMutableArray arrayWithArray:status];
        NSInteger *index_=[[Id objectAtIndex:path.row] integerValue]-1;
    [tempStatus replaceObjectAtIndex:index_ withObject:@"YES"];
    status=tempStatus;
        [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"Status"];
    }
//////
    
    
    
    
    
}

-(IBAction)ratingDown:(id)sender{
    NSIndexPath *path = [sender button_indexPath]; //извлекаем IndexPath с кнопки.
    NSInteger *index_=[[Id objectAtIndex:path.row] integerValue]-1;
    NSString *statusst=[[[NSUserDefaults standardUserDefaults] objectForKey: @"Status"] objectAtIndex:index_];// тут ошибка в размере массива и индекса
    if ([statusst isEqualToString:@"NO"])
    {
        UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Повторное голосование"
                                                              message:@"Вы уже голосовали ПРОТИВ!"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [simpleAlert show];
        
    }
    else
    {
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:rating];
    int ratf= [[rating objectAtIndex:path.row] intValue] ;
    ratf--;
    [tempArray replaceObjectAtIndex:path.row withObject:[NSString stringWithFormat:@"%d", ratf] ];
    rating=tempArray;
    
    [self down:[Id objectAtIndex:path.row]];// вызов в базу минус рейтинг

    UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Рейтиг Политиков"
                                                          message:@"Ваш голос ПРОТИВ учтен!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [simpleAlert show];
    
    
    [table reloadData];
    
    ////// cистема контроля
        NSMutableArray *tempStatus=[NSMutableArray arrayWithArray:status];
        NSInteger *index_=[[Id objectAtIndex:path.row] integerValue]-1;
        [tempStatus replaceObjectAtIndex:index_ withObject:@"NO"];
        status=tempStatus;
        [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"Status"];
        
    }
    //////
    
    
}




- (IBAction)all:(id)sender {
    self.navigationItem.prompt=nil;
    [self viewDidLoad];
}

    /*
    NSArray *tempjson=[jsondata valueForKey:@"response"];//для сортировки
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp1=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    NSMutableArray *temp3=[[NSMutableArray alloc] init];
    NSMutableArray *temp4=[[NSMutableArray alloc] init];
    NSMutableArray *temp5=[[NSMutableArray alloc] init];
    for (int i=0; i<tempjson.count;i++)
    {
       // if ([[[tempjson valueForKey:@"Gruppa"] objectAtIndex:i ]isEqualToString:@"World"])
       // {
            [temp addObject:[[tempjson valueForKey:@"Name"] objectAtIndex:i]];
            [temp1 addObject:[[tempjson valueForKey:@"Post"] objectAtIndex:i]];
            [temp2 addObject:[[tempjson valueForKey:@"Age"] objectAtIndex:i]];
            [temp3 addObject:[[tempjson valueForKey:@"Rating"] objectAtIndex:i]];
            [temp5 addObject:[[tempjson valueForKey:@"id"] objectAtIndex:i]];
            [temp4 addObject:[images objectAtIndex:i]];
            
            
            
       // }
        
    }
    
    name=temp;
    post=temp1;
    age=temp2;
    rating=temp3;
    images=temp4;
    Id=temp5;
    
    
    
    
    [table reloadData];
    
    
}*/
    
    

- (IBAction)guber:(id)sender {
    self.navigationItem.prompt=@"Губернаторы";
    NSArray *tempjson=[jsondata valueForKey:@"response"];//для сортировки
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp1=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    NSMutableArray *temp3=[[NSMutableArray alloc] init];
    NSMutableArray *temp4=[[NSMutableArray alloc] init];
    NSMutableArray *temp5=[[NSMutableArray alloc] init];
    for (int i=0; i<tempjson.count;i++)
    {
        if ([[[tempjson valueForKey:@"Gruppa"] objectAtIndex:i ]isEqualToString:@"Guber"])
        {
            [temp addObject:[[tempjson valueForKey:@"Name"] objectAtIndex:i]];
            [temp1 addObject:[[tempjson valueForKey:@"Post"] objectAtIndex:i]];
            [temp2 addObject:[[tempjson valueForKey:@"Age"] objectAtIndex:i]];
            [temp3 addObject:[[tempjson valueForKey:@"Rating"] objectAtIndex:i]];
            [temp5 addObject:[[tempjson valueForKey:@"id"] objectAtIndex:i]];
            [temp4 addObject:[images objectAtIndex:i]];
            
            
            
        }
        
    }
    
    name=temp;
    post=temp1;
    age=temp2;
    rating=temp3;
    images=temp4;
    Id=temp5;
    
    
    
    
    [table reloadData];
    
    
    
}
- (IBAction)gov:(id)sender {
    self.navigationItem.prompt=@"Правительство";
    NSArray *tempjson=[jsondata valueForKey:@"response"];//для сортировки
    NSMutableArray *tempimages=[[NSMutableArray alloc] init];
    tempimages=images2;
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp1=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    NSMutableArray *temp3=[[NSMutableArray alloc] init];
    NSMutableArray *temp4=[[NSMutableArray alloc] init];
    NSMutableArray *temp5=[[NSMutableArray alloc] init];
    for (int i=0; i<tempjson.count;i++)
    {
        if ([[[tempjson valueForKey:@"Gruppa"] objectAtIndex:i ]isEqualToString:@"Goverment"])
        {
            [temp addObject:[[tempjson valueForKey:@"Name"] objectAtIndex:i]];
            [temp1 addObject:[[tempjson valueForKey:@"Post"] objectAtIndex:i]];
            [temp2 addObject:[[tempjson valueForKey:@"Age"] objectAtIndex:i]];
            [temp3 addObject:[[tempjson valueForKey:@"Rating"] objectAtIndex:i]];
            [temp5 addObject:[[tempjson valueForKey:@"id"] objectAtIndex:i]];
            [temp4 addObject:[tempimages objectAtIndex:i]];
            
            
            
        }
        
    }
    
    name=temp;
    post=temp1;
    age=temp2;
    rating=temp3;
    images=temp4;
    Id=temp5;
    
    
    
    
    [table reloadData];
}
- (IBAction)deputat:(id)sender {
    self.navigationItem.prompt=@"Депутаты";
    
    NSArray *tempjson=[jsondata valueForKey:@"response"];//для сортировки
    
    NSMutableArray *tempimages=[[NSMutableArray alloc] init];
    tempimages=images2;
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp1=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    NSMutableArray *temp3=[[NSMutableArray alloc] init];
    NSMutableArray *temp4=[[NSMutableArray alloc] init];
    NSMutableArray *temp5=[[NSMutableArray alloc] init];
    for (int i=0; i<tempjson.count;i++)
    {
        if ([[[tempjson valueForKey:@"Gruppa"] objectAtIndex:i ]isEqualToString:@"Deputat"])
        {
            [temp addObject:[[tempjson valueForKey:@"Name"] objectAtIndex:i]];
            [temp1 addObject:[[tempjson valueForKey:@"Post"] objectAtIndex:i]];
            [temp2 addObject:[[tempjson valueForKey:@"Age"] objectAtIndex:i]];
            [temp3 addObject:[[tempjson valueForKey:@"Rating"] objectAtIndex:i]];
            [temp5 addObject:[[tempjson valueForKey:@"id"] objectAtIndex:i]];
            [temp4 addObject:[tempimages objectAtIndex:i]];
            
            
            
        }
        
    }
    
    name=temp;
    post=temp1;
    age=temp2;
    rating=temp3;
    images=temp4;
    Id=temp5;
    
    
    
    
    [table reloadData];
    
}

- (IBAction)world:(id)sender {
    self.navigationItem.prompt=@"Мир";
    
    NSArray *tempjson=[jsondata valueForKey:@"response"];//для сортировки
    
    NSMutableArray *tempimages=[[NSMutableArray alloc] init];
    tempimages=images2;
    
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp1=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    NSMutableArray *temp3=[[NSMutableArray alloc] init];
    NSMutableArray *temp4=[[NSMutableArray alloc] init];
    NSMutableArray *temp5=[[NSMutableArray alloc] init];
    for (int i=0; i<tempjson.count;i++)
    {
        if ([[[tempjson valueForKey:@"Gruppa"] objectAtIndex:i ]isEqualToString:@"World"])
        {
            [temp addObject:[[tempjson valueForKey:@"Name"] objectAtIndex:i]];
            [temp1 addObject:[[tempjson valueForKey:@"Post"] objectAtIndex:i]];
            [temp2 addObject:[[tempjson valueForKey:@"Age"] objectAtIndex:i]];
            [temp3 addObject:[[tempjson valueForKey:@"Rating"] objectAtIndex:i]];
            [temp5 addObject:[[tempjson valueForKey:@"id"] objectAtIndex:i]];
            [temp4 addObject:[tempimages objectAtIndex:i]];
            
            
            
        }
        
    }
    
    name=temp;
    post=temp1;
    age=temp2;
    rating=temp3;
    images=temp4;
    Id=temp5;


    
    
    [table reloadData];
    
}


@end


