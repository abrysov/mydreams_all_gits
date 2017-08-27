//
//  {{file_name}}
//
//
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator
//  Any changes will be lost.
//

#import "{{ storyboard_name_short }}CollectionViewCells.h"
{% for controller in controllers %}{% if controller.collectionViewCells %}
#import "{{controller.class}}.h"

const struct {{ controller.class }}StoryboardCollectionViewCell {{ controller.class }}StoryboardCollectionViewCell = {
{% for collectionViewCell in controller.collectionViewCells %}	.kPMReuseIdentifier{{ collectionViewCell.reuseIdentifier | capitaliseFirstChar }} = @"{{collectionViewCell.reuseIdentifier}}",{% endfor %}
};


@implementation {{ controller.class }} ( StoryboardCollectionViewCell )

@dynamic cell;

+(struct {{ controller.class }}StoryboardCollectionViewCell)cell {
   return {{ controller.class }}StoryboardCollectionViewCell;
}

-(struct {{ controller.class }}StoryboardCollectionViewCell)cell {
   return [self.class cell];
}

@end
{% endif %}{% endfor %}
