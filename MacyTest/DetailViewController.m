//
//  DetailViewController.m
//  MacyTest
//
//  Created by Mingyuan Chen on 2/16/16.
//  Copyright © 2016 Personal. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource =self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailedDataModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary* cellDataDic = [[NSDictionary alloc]init];
    cellDataDic = [self.detailedDataModelArr objectAtIndex:indexPath.row];
    
    NSString *formattedString = [NSString stringWithFormat:@"Freq: %@, Since: %@", cellDataDic[@"freq"], cellDataDic[@"since"]];
    
    cell.textLabel.text = cellDataDic[@"lf"];
    cell.detailTextLabel.text = formattedString;
    
    return cell;
    
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


@end
