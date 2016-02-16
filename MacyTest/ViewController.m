//
//  ViewController.m
//  MacyTest
//
//  Created by Mingyuan Chen on 2/16/16.
//  Copyright © 2016 Personal. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTalbeView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray* dataModelArr;

@end

@implementation ViewController


#pragma mark - ViewController LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Abbreviation Quick Look";
    
    _dataModelArr = [[NSArray alloc]init];
    self.myTalbeView.dataSource = self;
    self.myTalbeView.delegate = self;
    self.searchBar.delegate =self;
    self.myTalbeView.hidden = YES;

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)getLetterFromAbbreviationString:(NSString *)inputStr {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStirng = [NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@", inputStr];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    
    [manager GET:urlStirng parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",[responseObject class]);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.dataModelArr = [responseObject lastObject][@"lfs"];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.myTalbeView reloadData];
        self.myTalbeView.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alertController presentViewController:alertController animated:YES completion:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}


#pragma mark - SearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getLetterFromAbbreviationString:_searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary* cellDataDic = [[NSDictionary alloc]init];
    cellDataDic = [self.dataModelArr objectAtIndex:indexPath.row];
    
    NSString *formattedString = [NSString stringWithFormat:@"Freq: %@, Since: %@", cellDataDic[@"freq"], cellDataDic[@"since"]];
    
    cell.textLabel.text = cellDataDic[@"lf"];
    cell.detailTextLabel.text = formattedString;
    
    return cell;

}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"To DetailView"])
    {
        DetailViewController *detailView = [segue destinationViewController];
      
        
        NSIndexPath *selectedIndexPath = [self.myTalbeView indexPathForSelectedRow];
        
        detailView.detailedDataModelArr = [self.dataModelArr objectAtIndex:selectedIndexPath.row][@"vars"];
        detailView.title = [self.dataModelArr objectAtIndex:selectedIndexPath.row][@"lf"];
    }
}


@end




