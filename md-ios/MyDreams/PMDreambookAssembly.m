//
//  PMDreambookAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 17.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMDreambookLogic.h"
#import "PMDreambookVC.h"
#import "PMListDreamsLogic.h"
#import "PMListDreamsVC.h"
#import "PMListCompletedDreamsLogic.h"
#import "PMListCompletedDreamsVC.h"

#import "PMListDreamersLogic.h"
#import "PMListDreamersVC.h"

#import "PMFiltersDreamersLogic.h"
#import "PMFiltersDreamersVC.h"

#import "PMSelectCountryFilterLogic.h"
#import "PMSelectCountryFilterVC.h"

#import "PMSelectLocalityFilterLogic.h"
#import "PMSelectLocalityFilterVC.h"

#import "PMAddFulfilledDreamLogic.h"
#import "PMAddFulfilledDreamVC.h"

#import "PMFulFillDreamLogic.h"
#import "PMFulfillDreamVC.h"

#import "PMCreatePostLogic.h"
#import "PMCreatePostVC.h"

#import "PMPersonalListDreamsLogic.h"
#import "PMPersonalListDreamsVC.h"

#import "PMPersonalListFulfilledDreamsLogic.h"
#import "PMPersonalListFulfilledDreamsVC.h"

#import "PMListFollowersLogic.h"
#import "PMListFollowersVC.h"

#import "PMListFolloweesLogic.h"
#import "PMListFolloweesVC.h"

#import "PMListFriendsLogic.h"
#import "PMListFriendsVC.h"

#import "PMFriendshipRequestsLogic.h"
#import "PMFriendshipRequestsVC.h"

#import "PMContainedListPhotosLogic.h"
#import "PMContainedListPhotosVC.h"

#import "PMListCertificatesLogic.h"
#import "PMListCertificatesVC.h"

#import "PMListNewCertificatesLogic.h"
#import "PMListNewCertificatesVC.h"

#import "PMFullscreenLoadingView.h"
#import "PMNibManagement.h"

#import "PMDetailedPostLogic.h"
#import "PMDetailedPostVC.h"

#import "PMCertificateDetailLogic.h"
#import "PMCertificateDetailVC.h"

#import "PMDetailedDreamLogic.h"
#import "PMDetailedDreamVC.h"

#import "PMTOP100DreamsLogic.h"
#import "PMTOP100DreamsVC.h"

#import "PMEditDreamLogic.h"
#import "PMEditDreamVC.h"

#import "PMDetailedLikesLogic.h"
#import "PMDetailedLikesVC.h"

#import "PMEditPostLogic.h"
#import "PMEditPostVC.h"

@interface PMDreambookAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMDreambookAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMDreambookLogic *)myDreamBookLogic
{
    return [TyphoonDefinition withClass:[PMDreambookLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(profileApiClient)];
        [definition injectProperty:@selector(dreamerApiClient)];
        [definition injectProperty:@selector(friendsApiClient)];
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(userProvider)];
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(postMapper)];
        [definition injectProperty:@selector(router)];
        [definition injectProperty:@selector(baseUrl) with:TyphoonConfig(@"api.url")];
    }];
}

- (PMDreambookVC *)myDreamBookVC
{
    return [TyphoonDefinition withClass:[PMDreambookVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.myDreamBookLogic];
    }];
}

- (PMListDreamsLogic *)listDreamsLogic
{
    return [TyphoonDefinition withClass:[PMListDreamsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(dreamMapper)];
    }];
}

- (PMListDreamsVC *)listDreamsVC
{
    return [TyphoonDefinition withClass:[PMListDreamsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listDreamsLogic];
    }];
}

- (PMListCompletedDreamsLogic *)listCompletedDreamsLogic
{
    return [TyphoonDefinition withClass:[PMListCompletedDreamsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(dreamMapper)];
    }];
}

- (PMListCompletedDreamsVC *)listCompletedDreamsVC
{
    return [TyphoonDefinition withClass:[PMListCompletedDreamsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listCompletedDreamsLogic];
    }];
}

- (PMListDreamersLogic *)listDreamersLogic
{
    return [TyphoonDefinition withClass:[PMListDreamersLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamerApiClient)];
        [definition injectProperty:@selector(dreamerMapper)];
    }];
}

- (PMListDreamersVC *)listDreamersVC
{
    return [TyphoonDefinition withClass:[PMListDreamersVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listDreamersLogic];
    }];
}

- (PMFiltersDreamersLogic *)filtersDreamersLogic
{
    return [TyphoonDefinition withClass:[PMFiltersDreamersLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamerApiClient)];
    }];
}

- (PMFiltersDreamersVC *)filtersDreamersVC
{
    return [TyphoonDefinition withClass:[PMFiltersDreamersVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.filtersDreamersLogic];
    }];
}

- (PMSelectCountryFilterLogic *)selectCountryFilterLogic
{
    return [TyphoonDefinition withClass:[PMSelectCountryFilterLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(locationService)];
    }];
}

- (PMSelectCountryFilterVC *)selectCountryFilterVC
{
    return [TyphoonDefinition withClass:[PMSelectCountryFilterVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.selectCountryFilterLogic];
    }];
}

- (PMSelectLocalityFilterLogic *)selectLocalityFilterLogic
{
    return [TyphoonDefinition withClass:[PMSelectLocalityFilterLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(locationService)];
    }];
}

- (PMSelectLocalityFilterVC *)selectLocalityFilterVC
{
    return [TyphoonDefinition withClass:[PMSelectLocalityFilterVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.selectLocalityFilterLogic];
    }];
}

- (PMAddFulfilledDreamLogic *)addFulfilledDreamLogic
{
    return [TyphoonDefinition withClass:[PMAddFulfilledDreamLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
    }];
}

- (PMAddFulfilledDreamVC *)addFulfilledDreamVC
{
    return [TyphoonDefinition withClass:[PMAddFulfilledDreamVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.addFulfilledDreamLogic];
		[definition injectProperty:@selector(loadingView) with:self.fullscreenLoadingView];
    }];
}

- (PMFulfillDreamLogic *)fulfillDreamLogic
{
    return [TyphoonDefinition withClass:[PMFulfillDreamLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(router)];
    }];
}

- (PMFulfillDreamVC *)fulfillDreamVC
{
    return [TyphoonDefinition withClass:[PMFulfillDreamVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.fulfillDreamLogic];
		[definition injectProperty:@selector(loadingView) with:self.fullscreenLoadingView];
    }];
}

- (PMCreatePostLogic *)createPostLogic
{
    return [TyphoonDefinition withClass:[PMCreatePostLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(postApiClient)];
    }];
}

- (PMCreatePostVC *)createPostVC
{
    return [TyphoonDefinition withClass:[PMCreatePostVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.createPostLogic];
		[definition injectProperty:@selector(loadingView) with:self.fullscreenLoadingView];
    }];
}

- (PMPersonalListDreamsLogic *)personalListDreamsLogic
{
    return [TyphoonDefinition withClass:[PMPersonalListDreamsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(dreamMapper)];
    }];
}

- (PMPersonalListDreamsVC *)personalListDreamsVC
{
    return [TyphoonDefinition withClass:[PMPersonalListDreamsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.personalListDreamsLogic];
    }];
}

- (PMPersonalListFulfilledDreamsLogic *)personalListFulfilledDreamsLogic
{
    return [TyphoonDefinition withClass:[PMPersonalListFulfilledDreamsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(dreamMapper)];
    }];
}

- (PMPersonalListFulfilledDreamsVC *)personalListFulfilledDreamsVC
{
    return [TyphoonDefinition withClass:[PMPersonalListFulfilledDreamsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.personalListFulfilledDreamsLogic];
    }];
}

- (PMListFollowersLogic *)listFollowersLogic
{
    return [TyphoonDefinition withClass:[PMListFollowersLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(friendsApiClient)];
        [definition injectProperty:@selector(dreamerMapper)];
    }];
}

- (PMListFollowersVC *)listFollowersVC
{
    return [TyphoonDefinition withClass:[PMListFollowersVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listFollowersLogic];
    }];
}

- (PMListFolloweesLogic *)listFolloweesLogic
{
    return [TyphoonDefinition withClass:[PMListFolloweesLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(friendsApiClient)];
        [definition injectProperty:@selector(dreamerMapper)];
    }];
}

- (PMListFolloweesVC *)listFolloweesVC
{
    return [TyphoonDefinition withClass:[PMListFolloweesVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listFolloweesLogic];
    }];
}

- (PMListFriendsLogic *)listFriendsLogic
{
    return [TyphoonDefinition withClass:[PMListFriendsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(friendsApiClient)];
        [definition injectProperty:@selector(dreamerMapper)];
    }];
}

- (PMListFriendsVC *)listFriendsVC
{
    return [TyphoonDefinition withClass:[PMListFriendsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listFriendsLogic];
    }];
}

- (PMFriendshipRequestsLogic *)friendshipRequestsLogic
{
    return [TyphoonDefinition withClass:[PMFriendshipRequestsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(friendsApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMFriendshipRequestsVC *)friendshipRequestsVC
{
    return [TyphoonDefinition withClass:[PMFriendshipRequestsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.friendshipRequestsLogic];
    }];
}

- (PMContainedListPhotosLogic *)containedListPhotoLogic
{
    return [TyphoonDefinition withClass:[PMContainedListPhotosLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamerApiClient)];
        [definition injectProperty:@selector(photoMapper)];
        [definition injectProperty:@selector(profileApiClient)];
    }];
}

- (PMContainedListPhotosVC *)сontainedListPhotosVC
{
    return [TyphoonDefinition withClass:[PMContainedListPhotosVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.containedListPhotoLogic];
    }];
}

- (PMListCertificatesLogic *)listCertificatesLogic
{
    return [TyphoonDefinition withClass:[PMListCertificatesLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(certificatesApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMListCertificatesVC *)listCertificatesVC
{
    return [TyphoonDefinition withClass:[PMListCertificatesVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listCertificatesLogic];
    }];
}

- (PMListNewCertificatesLogic *)listNewCertificatesLogic
{
    return [TyphoonDefinition withClass:[PMListNewCertificatesLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(certificatesApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMListNewCertificatesVC *)listNewCertificatesVC
{
    return [TyphoonDefinition withClass:[PMListNewCertificatesVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listNewCertificatesLogic];
    }];
}

- (PMFullscreenLoadingView *)fullscreenLoadingView
{
	return [TyphoonDefinition withClass:[PMFullscreenLoadingView class]
			configuration:^(TyphoonDefinition *definition) {
			[definition useInitializer:@selector(viewFromNib)];
			[definition injectProperty:@selector(overlayWindow) with:self.applicationAssembly.overlayWindow];
	}];
}

- (PMDetailedPostLogic *)detailedPostLogic
{
    return [TyphoonDefinition withClass:[PMDetailedPostLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(userProvider)];
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(likeApiClient)];
        [definition injectProperty:@selector(commentsApiClient)];
    }];
}

- (PMDetailedPostVC *)detailedPostVC
{
    return [TyphoonDefinition withClass:[PMDetailedPostVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.detailedPostLogic];
    }];
}

- (PMCertificateDetailLogic *)certificateDetailLogic
{
	return [TyphoonDefinition withClass:[PMCertificateDetailLogic class] configuration:^(TyphoonDefinition *definition) {
		definition.parent = self.applicationAssembly.baseLogic;
		[definition injectProperty:@selector(imageDownloader)];
	}];
}

- (PMCertificateDetailVC *)certificateDetailVC
{
	return [TyphoonDefinition withClass:[PMCertificateDetailVC class] configuration:^(TyphoonDefinition *definition) {
		definition.parent = self.applicationAssembly.baseVC;
		[definition injectProperty:@selector(logic) with:self.certificateDetailLogic];
	}];
}

- (PMDetailedDreamLogic *)detailedDreamLogic
{
    return [TyphoonDefinition withClass:[PMDetailedDreamLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(userProvider)];
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(likeApiClient)];
    }];
}

- (PMDetailedDreamVC *)detailedDreamVC
{
    return [TyphoonDefinition withClass:[PMDetailedDreamVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.detailedDreamLogic];
    }];
}

- (PMTOP100DreamsLogic *)top100DreamsLogic
{
    return [TyphoonDefinition withClass:[PMTOP100DreamsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(likeApiClient)];
    }];
}

- (PMTOP100DreamsVC *)top100DreamsVC
{
    return [TyphoonDefinition withClass:[PMTOP100DreamsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.top100DreamsLogic];
    }];
}

- (PMEditDreamLogic *)editDreamLogic
{
    return [TyphoonDefinition withClass:[PMEditDreamLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMEditDreamLogic *)editDreamVC
{
    return [TyphoonDefinition withClass:[PMEditDreamVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.editDreamLogic];
        [definition injectProperty:@selector(loadingView) with:self.fullscreenLoadingView];
    }];
}

- (PMDetailedLikesLogic *)detailedLikesLogic
{
	return [TyphoonDefinition withClass:[PMDetailedLikesLogic class] configuration:^(TyphoonDefinition *definition) {
		definition.parent = self.applicationAssembly.baseLogic;
		[definition injectProperty:@selector(likeApiClient)];
		[definition injectProperty:@selector(imageDownloader)];
	}];
}

- (PMDetailedLikesVC *)detailedLikesVC
{
	return [TyphoonDefinition withClass:[PMDetailedLikesVC class] configuration:^(TyphoonDefinition *definition) {
		definition.parent = self.applicationAssembly.baseVC;
		[definition injectProperty:@selector(logic) with:self.detailedLikesLogic];
	}];
}

- (PMEditPostLogic *)editPostLogic
{
    return [TyphoonDefinition withClass:[PMEditPostLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMEditPostLogic *)editPostVC
{
    return [TyphoonDefinition withClass:[PMEditPostVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(logic) with:self.editPostLogic];
        [definition injectProperty:@selector(loadingView) with:self.fullscreenLoadingView];
    }];
}

@end
