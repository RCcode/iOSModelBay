//
//  MB_Utils.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Utils.h"

@implementation MB_Utils

static MB_Utils *util = nil;

+ (instancetype)shareUtil {
    if (util == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            util = [[MB_Utils alloc] init];
            
            util.fName     = @"";
            util.fGender   = -1;
            util.fCareerId = @"";
            
            util.rGender   = -1;
            util.rCareerId = @"";
            
            util.careerDic = @{@"01":LocalizedString(@"Model", nil),
                               @"02":LocalizedString(@"Actor", nil),
                               @"03":LocalizedString(@"Dancer", nil),
                               @"04":LocalizedString(@"Singer", nil),
                               @"05":LocalizedString(@"Photographer", nil),
                               @"06":LocalizedString(@"Fitness Trainer", nil),
                               @"07":LocalizedString(@"Makeup Artist", nil),
                               @"08":LocalizedString(@"Hair Stylist", nil),
                               @"09":LocalizedString(@"Stylist", nil),
                               @"10":LocalizedString(@"Nutritionist", nil),
                               @"11":LocalizedString(@"Fahsion Designer", nil),
                               @"12":LocalizedString(@"Agency", nil),
                               @"13":LocalizedString(@"Newface", nil)};
            
            util.eyeColor = @[@"", LocalizedString(@"Black", nil), LocalizedString(@"Blue", nil), LocalizedString(@"Brown", nil), LocalizedString(@"Green", nil), LocalizedString(@"Hazel", nil), LocalizedString(@"Other", nil)];
            
            util.skincolor = @[@"", LocalizedString(@"Black", nil), LocalizedString(@"White", nil), LocalizedString(@"Olive", nil), LocalizedString(@"Tanned", nil), LocalizedString(@"Other", nil)];

            util.haircolor = @[@"", LocalizedString(@"Black", nil), LocalizedString(@"Blonde", nil), LocalizedString(@"Brown", nil), LocalizedString(@"Grey", nil), LocalizedString(@"Red", nil), LocalizedString(@"Other", nil),];
            
            util.shoesize = @[@"", @"2", @"2.5", @"3", @"3.5", @"4", @"4.5", @"5", @"5.5", @"6", @"6.5", @"7", @"7.5", @"8", @"8.5", @"9", @"9.5", @"10", @"10.5", @"11", @"11.5", @"12", @"12.5", @"13", @"13.5", @"14", @"14.5"];
           
            util.dress = @[@"", @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60"];
            
            util.height = @[@"", @"1' 0''/30cm", @"1' 1''/33cm", @"1' 2''/35cm", @"1' 3''/38cm", @"1' 4''/40cm", @"1' 5''/43cm", @"1' 6''/45cm", @"1' 7''/48cm", @"1' 8''/50cm", @"1' 9''/53cm", @"1' 10''/55cm", @"1' 11''/58cm", @"2' 0''/61cm", @"2' 1''/63cm", @"2' 2''/66cm", @"2' 3''/68cm", @"2' 4''/71cm", @"2' 5''/73cm", @"2' 6''/76cm", @"2' 7''/78cm", @"2' 8''/81cm", @"2' 9''/83cm", @"2' 10''/86cm", @"2' 11''/89cm", @"3' 0''/91cm", @"3' 1''/94cm", @"3' 2''/96cm", @"3' 3''/99cm", @"3' 4''/101cm", @"3' 5''/104cm", @"3' 6''/106cm", @"3' 7''/109cm", @"3' 8''/111cm", @"3' 9''/114cm", @"3' 10''/117cm", @"3' 11''/119cm", @"4' 0''/122cm", @"4' 1''/124cm", @"4' 2''/127cm", @"4' 3''/129cm", @"4' 4''/132cm", @"4' 5''/134cm", @"4' 6''/137cm", @"4' 7''/139cm", @"4' 8''/142cm", @"4' 9''/145cm", @"4' 10''/147cm", @"4' 11''/150cm", @"5' 0''/152cm", @"5' 1''/155cm", @"5' 2''/157cm", @"5' 3''/160cm", @"5' 4''/162cm", @"5' 5''/165cm", @"5' 6''/167cm", @"5' 7''/170cm", @"5' 8''/173cm", @"5' 9''/175cm", @"5' 10''/178cm", @"5' 11''/180cm", @"6' 0''/183cm", @"6' 1''/185cm", @"6' 2''/188cm", @"6' 3''/190cm", @"6' 4''/193cm", @"6' 5''/195cm", @"6' 6''/198cm", @"6' 7''/201cm", @"6' 8''/203cm", @"6' 9''/206cm", @"6' 10''/208cm", @"6' 11''/211cm", @"7' 0''/213cm", @"7' 1''/216cm", @"7' 2''/218cm", @"7' 3''/221cm", @"7' 4''/223cm", @"7' 5''/226cm", @"7' 6''/229cm"];
            
            util.weight = @[@"", @"10 lbs/5 kg", @"15 lbs/7 kg", @"20 lbs/9 kg", @"25 lbs/11 kg", @"30 lbs/14 kg", @"35 lbs/16 kg", @"40 lbs/18 kg", @"45 lbs/20 kg", @"50 lbs/23 kg", @"55 lbs/25 kg", @"60 lbs/27 kg", @"65 lbs/29 kg", @"70 lbs/32 kg", @"75 lbs/34 kg", @"80 lbs/36 kg", @"85 lbs/39 kg", @"90 lbs/41 kg", @"95 lbs/43 kg", @"100 lbs/45 kg", @"105 lbs/48 kg", @"110 lbs/50 kg", @"115 lbs/52 kg", @"120 lbs/54 kg", @"125 lbs/57 kg", @"130 lbs/59 kg", @"135 lbs/61 kg", @"140 lbs/64 kg", @"145 lbs/66 kg", @"150 lbs/68 kg", @"155 lbs/70 kg", @"160 lbs/73 kg", @"165 lbs/75 kg", @"170 lbs/77 kg", @"175 lbs/79 kg", @"180 lbs/82 kg", @"185 lbs/84 kg", @"190 lbs/86 kg", @"195 lbs/88 kg", @"200 lbs/91 kg", @"205 lbs/93 kg", @"210 lbs/95 kg", @"215 lbs/98 kg", @"220 lbs/100 kg", @"225 lbs/102 kg", @"230 lbs/104 kg", @"235 lbs/107 kg", @"240 lbs/109 kg", @"245 lbs/111 kg", @"250 lbs/113 kg", @"255 lbs/116 kg", @"260 lbs/118 kg", @"265 lbs/120 kg", @"270 lbs/122 kg", @"275 lbs/125 kg", @"280 lbs/127 kg", @"285 lbs/129 kg", @"290 lbs/132 kg", @"295 lbs/134 kg", @"300 lbs/136 kg", @"305 lbs/138 kg", @"310 lbs/141 kg", @"315 lbs/143 kg", @"320 lbs/145 kg"];
            
            util.chest = @[@"", @"24''/ 60 cm", @"25''/ 63 cm", @"26''/ 66 cm", @"27''/ 68 cm", @"28''/ 71 cm", @"29''/ 73 cm", @"30''/ 76 cm", @"31''/ 78 cm", @"32''/ 81 cm", @"33''/ 83 cm", @"34''/ 86 cm", @"35''/ 88 cm", @"36''/ 91 cm", @"37''/ 93 cm", @"38''/ 96 cm", @"39''/ 99 cm", @"40''/ 101 cm", @"41''/ 104 cm", @"42''/ 106 cm", @"43''/ 109 cm", @"44''/ 111 cm", @"45''/ 114 cm", @"46''/ 116 cm", @"47''/ 119 cm", @"48''/ 121 cm", @"49''/ 124 cm", @"50''/ 127 cm", @"51''/ 129 cm", @"52''/ 132 cm", @"53''/ 134 cm", @"54''/ 137 cm", @"55''/ 139 cm", @"56''/ 142 cm", @"57''/ 144 cm", @"58''/ 147 cm", @"59''/ 149 cm", @"60''/ 152 cm", @"61''/ 154 cm", @"62''/ 157 cm", @"63''/ 160 cm", @"64''/ 162 cm", @"65''/ 165 cm", @"66''/ 167 cm", @"67''/ 170 cm", @"68''/ 172 cm", @"69''/ 175 cm", @"70''/ 177 cm"];
            
            util.waist = @[@"", @"10''/ 25 cm", @"11''/ 27 cm", @"12''/ 30 cm", @"13''/ 33 cm", @"14''/ 35 cm", @"15''/ 38 cm", @"16''/ 40 cm", @"17''/ 43 cm", @"18''/ 45 cm", @"19''/ 48 cm", @"20''/ 50 cm", @"21''/ 53 cm", @"22''/ 55 cm", @"23''/ 58 cm", @"24''/ 60 cm", @"25''/ 63 cm", @"26''/ 66 cm", @"27''/ 68 cm", @"28''/ 71 cm", @"29''/ 73 cm", @"30''/ 76 cm", @"31''/ 78 cm", @"32''/ 81 cm", @"33''/ 83 cm", @"34''/ 86 cm", @"35''/ 88 cm", @"36''/ 91 cm", @"37''/ 93 cm", @"38''/ 96 cm", @"39''/ 99 cm", @"40''/ 101 cm", @"41''/ 104 cm", @"42''/ 106 cm", @"43''/ 109 cm", @"44''/ 111 cm", @"45''/ 114 cm", @"46''/ 116 cm", @"47''/ 119 cm", @"48''/ 121 cm", @"49''/ 124 cm", @"50''/ 127 cm", @"51''/ 129 cm", @"52''/ 132 cm", @"53''/ 134 cm", @"54''/ 137 cm", @"55''/ 139 cm", @"56''/ 142 cm", @"57''/ 144 cm", @"58''/ 147 cm", @"59''/ 149 cm", @"60''/ 152 cm", @"61''/ 154 cm", @"62''/ 157 cm", @"63''/ 160 cm", @"64''/ 162 cm", @"65''/ 165 cm", @"66''/ 167 cm", @"67''/ 170 cm", @"68''/ 172 cm", @"69''/ 175 cm", @"70''/ 177 cm"];
            
            util.hips = @[@"", @"10''/ 25 cm", @"11''/ 27 cm", @"12''/ 30 cm", @"13''/ 33 cm", @"14''/ 35 cm", @"15''/ 38 cm", @"16''/ 40 cm", @"17''/ 43 cm", @"18''/ 45 cm", @"19''/ 48 cm", @"20''/ 50 cm", @"21''/ 53 cm", @"22''/ 55 cm", @"23''/ 58 cm", @"24''/ 60 cm", @"25''/ 63 cm", @"26''/ 66 cm", @"27''/ 68 cm", @"28''/ 71 cm", @"29''/ 73 cm", @"30''/ 76 cm", @"31''/ 78 cm", @"32''/ 81 cm", @"33''/ 83 cm", @"34''/ 86 cm", @"35''/ 88 cm", @"36''/ 91 cm", @"37''/ 93 cm", @"38''/ 96 cm", @"39''/ 99 cm", @"40''/ 101 cm", @"41''/ 104 cm", @"42''/ 106 cm", @"43''/ 109 cm", @"44''/ 111 cm", @"45''/ 114 cm", @"46''/ 116 cm", @"47''/ 119 cm", @"48''/ 121 cm", @"49''/ 124 cm", @"50''/ 127 cm", @"51''/ 129 cm", @"52''/ 132 cm", @"53''/ 134 cm", @"54''/ 137 cm", @"55''/ 139 cm", @"56''/ 142 cm", @"57''/ 144 cm", @"58''/ 147 cm", @"59''/ 149 cm", @"60''/ 152 cm", @"61''/ 154 cm", @"62''/ 157 cm", @"63''/ 160 cm", @"64''/ 162 cm", @"65''/ 165 cm", @"66''/ 167 cm", @"67''/ 170 cm", @"68''/ 172 cm", @"69''/ 175 cm", @"70''/ 177 cm"];
            
            util.areaModel = @[LocalizedString(@"Fashion/Editorial", nil), LocalizedString(@"Runway", nil), LocalizedString(@"Sport", nil), LocalizedString(@"Casual", nil), LocalizedString(@"Swimwear", nil), LocalizedString(@"Print", nil), LocalizedString(@"Hair/Makeup", nil), LocalizedString(@"Parts Modeling", nil), LocalizedString(@"SkillPromotional", nil), LocalizedString(@"Artists Model", nil), LocalizedString(@"Glamour", nil), LocalizedString(@"Lingerie/Body", nil), LocalizedString(@"Artistic", nil), LocalizedString(@"Art Nude", nil), LocalizedString(@"Nude", nil)];
            
            util.areaPhoto = @[LocalizedString(@"Landscape", nil), LocalizedString(@"Advertising", nil), LocalizedString(@"Lifestyle", nil), LocalizedString(@"Architectural", nil), LocalizedString(@"Lingerie/Body", nil), LocalizedString(@"Artistic", nil), LocalizedString(@"Music", nil), LocalizedString(@"Athletic", nil), LocalizedString(@"Nude", nil), LocalizedString(@"Beauty", nil), LocalizedString(@"Portrait", nil), LocalizedString(@"Black and White", nil), LocalizedString(@"Reportage/Journalism", nil), LocalizedString(@"Celebrity/Entertainment", nil), LocalizedString(@"Runway", nil), LocalizedString(@"Fashion/Editorial", nil), LocalizedString(@"Still Life", nil), LocalizedString(@"Fine Art", nil), LocalizedString(@"Swimwear", nil), LocalizedString(@"Glamour", nil), LocalizedString(@"Wedding", nil)];
            
            util.experience = @[@"", LocalizedString(@"No Experience", nil), LocalizedString(@"Some Experience", nil), LocalizedString(@"Experienced", nil), LocalizedString(@"Very Experienced", nil), LocalizedString(@"Advanced", nil)];

            util.gender = @[@"", LocalizedString(@"Women", nil), LocalizedString(@"Men", nil)];
            
            util.country = @[@"", @"Afghanistan", @"Albania",@"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Bouvet Island", @"Brazil", @"British Indian Ocean Territory", @"Brunei Darussalam", @"Bulgaria", @"Burkina Faso", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"Central African Republic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos (Keeling) Islands", @"Colombia", @"Comoros", @"Congo", @"Congo, The Democratic Republic Of The", @"Cook Islands", @"Costa Rica", @"Cote D\"Ivoire", @"Croatia (local name: Hrvatska)", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominica", @"Dominican Republic", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"Falkland Islands (Malvinas)", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"France Metropolitan", @"French Guiana", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guinea", @"Guinea-Bissau", @"Guyana", @"Haiti", @"Heard and Mc Donald Islands", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran (Islamic Republic of)", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Jamaica", @"Japan", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Kuwait", @"Kyrgyzstan", @"Lao People\"s Democratic Republic", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libyan Arab Jamahiriya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestine", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russian Federation", @"Rwanda", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Vincent and the Grenadines", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia (Slovak Republic)", @"Slovenia", @"Solomon Islands", @"Somalia", @"South Africa", @"South Korea", @"Spain", @"Sri Lanka", @"St. Helena", @"St. Pierre and Miquelon", @"Sudan", @"Suriname", @"Svalbard and Jan Mayen Islands", @"Swaziland", @"Sweden", @"Switzerland", @"Syrian Arab Republic", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"The former Yugoslav Republic of Macedonia", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"United States Minor Outlying Islands", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City State (Holy See)", @"Venezuela", @"Vietnam", @"Virgin Islands (British)", @"Virgin Islands (U.S.)", @"Wallis And Futuna Islands", @"Western Sahara", @"Yemen", @"Yugoslavia", @"Zambia", @"Zimbabwe"];

            util.mapArray = @[@"Eye Color",@"Skin Color",@"Hair Color",@"Shoes",@"Dress",@"Height",@"Weight",@"Chest",@"Waist",@"Hips",@"areaModel",@"areaPhoto",@"Experiences",@"Gender",@"Country",@"Age",@"Contracts",@"Email",@"Website"];
            
            util.optionsDic = @{@(0):util.eyeColor,
                                @(1):util.skincolor,
                                @(2):util.haircolor,
                                @(3):util.shoesize,
                                @(4):util.dress,
                                @(5):util.height,
                                @(6):util.weight,
                                @(7):util.chest,
                                @(8):util.waist,
                                @(9):util.hips,
                                @(10):util.areaModel,
                                @(11):util.areaPhoto,
                                @(12):util.experience,
                                @(13):util.gender,
                                @(14):util.country,};
        });
    }
    
    return util;
}

+ (void)showPromptWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode             = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:17.0];
    [hud hide:YES afterDelay:0.8];
}

+ (void)showAlertViewWithMessage:(NSString *)string {
    if (string != nil && ![string isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:self cancelButtonTitle:LocalizedString(@"Select_confire", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

+ (NSString *)dateWithTimeInterval:(double)timeInterval fromTimeZone:(NSString *)zone {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"Z"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    //+0800
    NSString *timeZoneZ = [dateFormatter stringFromDate:[NSDate date]];
    NSRange range = NSMakeRange(0, 3);
    //+08
    NSString *timeZoneInt = [timeZoneZ substringWithRange:range];
    
    //时区相差时间戳
    double interval = ([timeZoneInt integerValue] - [zone integerValue]) * 60;
    //按现在时区算的时间戳应该是：
    NSTimeInterval second = timeInterval + interval;
    //那么对应的date是：
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    
    //设置格式为2015.07.03 18:12
    [dateFormatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    
    return [dateFormatter stringFromDate:date];
}

@end
