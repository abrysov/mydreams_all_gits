//
//  {{file_name}}
//
// 
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator
//  Any changes will be lost.
//

#import <Foundation/Foundation.h>
{% for controller in controllers %}{% if controller.tableViewCells %}
#import "{{controller.class}}.h"

extern const struct {{ controller.class }}StoryboardTableViewCell 
{
{% for tableViewCell in controller.tableViewCells %}	__unsafe_unretained NSString*  kPMReuseIdentifier{{ tableViewCell.reuseIdentifier | capitaliseFirstChar }};{% endfor %}
} {{ controller.class }}StoryboardTableViewCell;


@interface {{ controller.class }} ( StoryboardTableViewCell )

@property (assign, nonatomic, readonly) struct {{ controller.class }}StoryboardTableViewCell cell;

+(struct {{ controller.class }}StoryboardTableViewCell)cell;

@end

{% endif %}{% endfor %}