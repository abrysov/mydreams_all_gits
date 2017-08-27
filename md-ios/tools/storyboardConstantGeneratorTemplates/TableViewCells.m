//
//  {{file_name}}
//
//
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator
//  Any changes will be lost.
//

#import "{{ storyboard_name_short }}TableViewCells.h"
{% for controller in controllers %}{% if controller.tableViewCells %}
#import "{{controller.class}}.h"

const struct {{ controller.class }}StoryboardTableViewCell {{ controller.class }}StoryboardTableViewCell = {
{% for tableViewCell in controller.tableViewCells %}	.kPMReuseIdentifier{{ tableViewCell.reuseIdentifier | capitaliseFirstChar }} = @"{{tableViewCell.reuseIdentifier}}",{% endfor %}
};


@implementation {{ controller.class }} ( StoryboardTableViewCell )

@dynamic cell;

+(struct {{ controller.class }}StoryboardTableViewCell)cell {
   return {{ controller.class }}StoryboardTableViewCell;
}

-(struct {{ controller.class }}StoryboardTableViewCell)cell {
   return [self.class cell];
}

@end
{% endif %}{% endfor %}
