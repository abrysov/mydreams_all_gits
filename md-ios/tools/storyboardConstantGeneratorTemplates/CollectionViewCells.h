//
//  {{file_name}}
//
// 
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator
//  Any changes will be lost.
//

#import <Foundation/Foundation.h>
{% for controller in controllers %}{% if controller.collectionViewCells %}
#import "{{controller.class}}.h"

extern const struct {{ controller.class }}StoryboardCollectionViewCell 
{
{% for collectionViewCell in controller.collectionViewCells %}	__unsafe_unretained NSString*  kPMReuseIdentifier{{ collectionViewCell.reuseIdentifier | capitaliseFirstChar }};{% endfor %}
} {{ controller.class }}StoryboardCollectionViewCell;


@interface {{ controller.class }} ( StoryboardCollectionViewCell )

@property (assign, nonatomic, readonly) struct {{ controller.class }}StoryboardCollectionViewCell cell;

+(struct {{ controller.class }}StoryboardCollectionViewCell)cell;

@end

{% endif %}{% endfor %}