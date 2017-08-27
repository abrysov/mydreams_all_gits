package com.mydreams.android.adapters;

import android.graphics.Bitmap;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.R;
import com.mydreams.android.components.SquareImageView;
import com.mydreams.android.database.PaginationHelper;
import com.mydreams.android.components.StringAppendingComponent;
import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.Dream;
import com.mydreams.android.models.Dreamer;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.Pagination;
import com.mydreams.android.utils.CustomDateUtils;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;

import java.util.List;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by mikhail on 11.05.16.
 */
public class DreamListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<Dream> dreamList;
    private EndlessScrollListener endlessScrollListener;
    private final int VIEW_ITEM = 1;
    private final int VIEW_PROGRESS = 0;
    private int visibleThreshold = 2;
    private int lastVisibleItem, totalItemCount;
    private LinearLayoutManager linearLayoutManager;
    private Pagination pagination;

    @Inject
    ImageLoader imageLoader;
    @Inject
    DisplayImageOptions imageOptions;
    @Inject
    PaginationHelper paginationHelper;

    public DreamListAdapter(List<Dream> dreamList, RecyclerView recyclerView) {
        App.getComponent().inject(this);
        this.dreamList = dreamList;
        linearLayoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();

        recyclerView.addOnScrollListener(onScrollListener);
    }

    private RecyclerView.OnScrollListener onScrollListener = new RecyclerView.OnScrollListener() {
        @Override
        public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
            super.onScrolled(recyclerView, dx, dy);

            totalItemCount = linearLayoutManager.getItemCount();
            lastVisibleItem = linearLayoutManager.findLastVisibleItemPosition();
            if (totalItemCount <= (lastVisibleItem + visibleThreshold)) {
                if (endlessScrollListener != null) {
                    pagination = paginationHelper.getPaginationData();
                    if (pagination.getTotalCount() != totalItemCount) {
                        endlessScrollListener.onLoadMore(pagination.getPage());
                    }
                }
            }
        }
    };

    public void refresh(List<Dream> dreamList) {
        this.dreamList = dreamList;
    }

    public void setEndlessScrollListener(EndlessScrollListener endlessScrollListener) {
        this.endlessScrollListener = endlessScrollListener;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolder;
        if (viewType == VIEW_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.dream_item, parent, false);
            viewHolder = new ViewHolder(view);
        } else {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.footer_progress_bar, parent, false);
            viewHolder = new ProgressViewHolder(view);
        }

        return viewHolder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int position) {
        if (viewHolder instanceof ViewHolder) {
            final Dream dream = dreamList.get(position);

            final ViewHolder holder = (ViewHolder) viewHolder;

            Dreamer dreamer = dream.getDreamer();
            Avatar avatar = dreamer.getAvatar();

            imageLoader.displayImage(avatar.getMediumUrl(), holder.userPhoto, imageOptions);
            holder.userFullName.setText(dream.getDreamer().getFullName());
            holder.ageAndLocationUser.setText(StringAppendingComponent.getDreamerInfo(dreamer));
            holder.userStatus.setText(dream.getCerificateType());
            imageLoader.displayImage(dream.getPhoto().getLarge(), holder.imgDream, imageOptions, new SimpleImageLoadingListener() {
                @Override
                public void onLoadingStarted(String imageUri, View view) {
                    holder.progressBarLoadingImage.setVisibility(View.VISIBLE);
                }

                @Override
                public void onLoadingFailed(String imageUri, View view, FailReason failReason) {
                    holder.progressBarLoadingImage.setVisibility(View.GONE);
                }

                @Override
                public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
                    holder.progressBarLoadingImage.setVisibility(View.GONE);
                }

                @Override
                public void onLoadingCancelled(String imageUri, View view) {
                    holder.progressBarLoadingImage.setVisibility(View.GONE);
                }
            });
            holder.titleDream.setText(dream.getTitle());
            holder.descriptionDream.setText(dream.getDescription());
            holder.countLikes.setText(String.valueOf(dream.getLikesCount()));
            holder.countComments.setText(String.valueOf(dream.getCommentsCount()));
            holder.countLaunches.setText(String.valueOf(dream.getLaunchesCount()));
            holder.publicationTime.setText(CustomDateUtils.getDateFormat(dream.getCreatedAt()));
            if (dreamer.getGender() != null && dreamer.getGender().equals(Field.MALE)) {
                holder.imgUserGender.setBackgroundResource(R.mipmap.ic_gender_male);
            } else {
                holder.imgUserGender.setBackgroundResource(R.mipmap.ic_gender_female);
            }
        } else if (viewHolder instanceof ProgressViewHolder) {
            ProgressViewHolder progressViewHolder = (ProgressViewHolder) viewHolder;
            progressViewHolder.footerProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemViewType(int position) {
        return position < dreamList.size() ? VIEW_ITEM : VIEW_PROGRESS;
    }

    @Override
    public int getItemCount() {
        pagination = paginationHelper.getPaginationData();
        if (dreamList == null) {
            return 0;
        } else {
            if (pagination.getTotalCount() == dreamList.size()) {
                return dreamList.size();
            } else {
                return dreamList.size() + 1;
            }
        }
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        @Bind(R.id.user_photo)
        CircleImageView userPhoto;
        @Bind(R.id.user_full_name)
        TextView userFullName;
        @Bind(R.id.img_user_gender)
        ImageView imgUserGender;
        @Bind(R.id.age_and_location_user)
        TextView ageAndLocationUser;
        @Bind(R.id.publication_time)
        TextView publicationTime;
        @Bind(R.id.user_status)
        TextView userStatus;
        @Bind(R.id.img_dream)
        SquareImageView imgDream;
        @Bind(R.id.title_dream)
        TextView titleDream;
        @Bind(R.id.dream_description)
        TextView descriptionDream;
        @Bind(R.id.count_likes)
        TextView countLikes;
        @Bind(R.id.count_comments)
        TextView countComments;
        @Bind(R.id.count_launches)
        TextView countLaunches;
        @Bind(R.id.progress_bar_loading_image)
        ProgressBar progressBarLoadingImage;

        public ViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }

    public class ProgressViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.footer_progress_bar)
        ProgressBar footerProgressBar;

        public ProgressViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }

    public interface EndlessScrollListener {
        boolean onLoadMore(int pageNumber);
    }
}
