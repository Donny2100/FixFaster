//
//  UploadViewController.m
//  FixItFaster
//
//  Created by iOS Master on 12/13/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController () <FLNiceSpinnerDelegate, MKMapViewDelegate>
{
    NSArray *mainCategories;
    NSArray *subCategories;
    UITableView *autocompleteTableView;  // added by chao
    NSMutableArray *autocompletePlaces;
    NSMutableArray *places;
}

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
    [self setupView];
    
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
    NSLog(@"autocomplete tableview appearing");
  autocompleteTableView.hidden = NO;
  [self searchAutocompleteEntriesWithSubstring:string];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self searchAutocompleteEntriesWithSubstring: @"Begin"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    autocompleteTableView.hidden = YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    autocompleteTableView.hidden = YES;
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
  
  // Put anything that starts with this substring into the autocompleteUrls array
  // The items in this array is what will show up in the table view
//  [autocompletePlaces removeAllObjects];
//  for(NSString *curString in places) {
//    NSRange substringRange = [curString rangeOfString:substring];
//    if (substringRange.location == 0) {
//      [autocompletePlaces addObject:curString];
//    }
//  }
//  [autocompleteTableView reloadData];
    
    NSString *str_Search_String=[NSString stringWithFormat:@"%@",self.searchTf.text];
    if([substring isEqualToString:@"Begin"])
        str_Search_String=[NSString stringWithFormat:@"%@",self.searchTf.text];
    else if([substring isEqualToString:@""])
        str_Search_String = [str_Search_String substringToIndex:[str_Search_String length] - 1];
    else
        str_Search_String=[str_Search_String stringByAppendingString:substring];

    autocompletePlaces=[[NSMutableArray alloc] init];
    if(str_Search_String.length>0)
    {
        NSInteger counter = 0;
        for(NSString *name in places)
        {
            NSRange r = [name rangeOfString:str_Search_String options:NSCaseInsensitiveSearch];
            if(r.length>0)
            {
                [autocompletePlaces addObject:name];
            }

            counter++;

        }

        if (autocompletePlaces.count > 0)
        {
//            NSLog(@"%@",muary_Interest_Sub);
            autocompleteTableView.hidden = FALSE;
            [autocompleteTableView reloadData];
        }
        else
        {
           autocompleteTableView.hidden = TRUE;
        }



    }
    else
    {
        [autocompleteTableView  setHidden:TRUE];

    }
}

- (void)initValue {
    mainCategories = @[@"STRUCTURAL SYSTEMS", @"ELECTRICAL SYSTEMS", @"HEATING, VENTILATION AND AIR CONDITIONING SYSTEMS", @"PLUMBING SYSTEMS", @"APPLIANCES"];
     subCategories = @[@"Foundations", @"Grading and Drainage", @"Roof Covering Materials", @"Roof Structures and Attics", @"Walls (Interior and Exterior)"];
    
    places = [[NSMutableArray alloc]initWithObjects:@"Cricket",@"Dancing",@"Painting",@"Swiming",@"guitar",@"movie",@"boxing",@"drum",@"hockey",@"chessing",@"gamming",
    @"hunting",@"killing",@"shoping",@"jamm", @"zooming", nil];
    autocompletePlaces = [[NSMutableArray alloc] init];
}

- (void)setupView {
    self.mainDropDown.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mainDropDown.layer.borderWidth = 0.5;
    self.mainDropDown.layer.cornerRadius = 5;
    
    self.subDropDown.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.subDropDown.layer.borderWidth = 0.5;
    self.subDropDown.layer.cornerRadius = 5;
    
    UIImageView *envelopeView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 25, 25)];
    envelopeView.image = [UIImage imageNamed:@"search.png"];
    envelopeView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *test = [[UIView alloc]initWithFrame:CGRectMake(4, 0, 25, 25)];
    [test addSubview:envelopeView];
    [self.searchTf.leftView setFrame:envelopeView.frame];
    self.searchTf.leftView =test;
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    
    self.uploadBt.layer.cornerRadius = 5;
 
    /* added by  chao*/
    autocompleteTableView = [[UITableView alloc] initWithFrame:
    CGRectMake(self.searchTf.frame.origin.x, self.searchTf.frame.origin.y+35, self.searchTf.bounds.size.width, 120) style:UITableViewStylePlain];
    
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [autocompleteTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    [self.view addSubview:autocompleteTableView];
    self.searchTf.delegate = self;
    /* end by chao  */
    
}
- (IBAction)cancelClicked:(id)sender {
    [self closeAllMenu];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)uploadClicked:(id)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [autocompletePlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }
    cell.textLabel.text = [autocompletePlaces objectAtIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchTf.text = [autocompletePlaces objectAtIndex:indexPath.row];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}

- (void)closeAllMenu {
    [self.mainDropDown closeAllComponentsAnimated:YES];
    [self.subDropDown closeAllComponentsAnimated:YES];
}

//------------------
// MARK: Single Drop
//------------------
- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    if(dropdownMenu == self.mainDropDown) {
        return mainCategories.count;
    } else {
        return subCategories.count;
    }
}

- (NSString*)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(dropdownMenu == self.mainDropDown) {
        return mainCategories[row];
    } else {
        return subCategories[row];
    }
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row == - 1) {
        return;
    }
    
    if(dropdownMenu == self.mainDropDown) {
        [self.mainCategoryLb setText:mainCategories[row]];
    } else {
        [self.subCategoryLb setText:subCategories[row]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
