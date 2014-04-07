//
//  TWIncidentCell.m
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import "TWIncidentCell.h"

@implementation TWIncidentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    // Layout subviews with respect to |contentRect|
    
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
  
    self.detailTextLabel.font = [UIFont fontWithName:self.detailTextLabel.font.fontName size:13.0];
    
    CGSize sizeOfString = [self.textLabel.text sizeWithFont:self.textLabel.font];
    CGFloat positionX = 8.0f + 80.0f;
    CGFloat positionY = 8.0f;
    CGFloat width  = contentRect.size.width - 2.0f * 8.0f - 80.0f;
    CGFloat height = sizeOfString.height;
    CGRect textLabelFrame = CGRectMake(positionX, positionY, width, height );
    self.textLabel.frame = textLabelFrame;
    
    
    CGFloat detailPositionX = 8.0f + 80.0f;
    CGFloat detailPositionY = height + 2.0f * 8.0f;
    CGFloat detailWidth  = contentRect.size.width - 2.0f * 8.0f - 80.0f;
    CGFloat detailHeight = contentRect.size.height - height - 3.0f*8.0f;
    
    CGRect detailTextLabelFrame = CGRectMake(detailPositionX, detailPositionY, detailWidth, detailHeight );
    self.detailTextLabel.frame = detailTextLabelFrame;    
    
    self.detailTextLabel.numberOfLines = 4;
    
    self.imageView.frame = CGRectMake(19.0f, 19.0f, 50.0f, 50.0f);

    
}

@end
