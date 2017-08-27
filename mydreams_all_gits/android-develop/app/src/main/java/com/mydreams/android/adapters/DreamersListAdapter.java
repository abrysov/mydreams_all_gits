package com.mydreams.android.adapters;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.R;
import com.mydreams.android.components.StringAppendingComponent;
import com.mydreams.android.database.PaginationHelper;
import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.Dreamer;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.Pagination;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by mikhail on 20.05.16.
 */
public class DreamersListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<Dreamer> dreamersList;
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

    public DreamersListAdapter(List<Dreamer> dreamersList, RecyclerView recyclerView) {
        App.getComponent().inject(this);
        this.dreamersList = dreamersList;

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

    public void refresh(List<Dreamer> dreamersList) {
        this.dreamersList = dreamersList;
    }

    public void setEndlessScrollListener(EndlessScrollListener endlessScrollListener) {
        this.endlessScrollListener = endlessScrollListener;
    }

    @Override
    public int getItemViewType(int position) {
        return position < dreamersList.size() ? VIEW_ITEM : VIEW_PROGRESS;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolder;
        if (viewType == VIEW_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.dreamer_item, parent, false);
            viewHolder = new ViewHolder(view);
        } else {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.footer_progress_bar, parent, false);
            viewHolder = new ProgressViewHolder(view);
        }

        return viewHolder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int position) {
        if (viewHolder instanceof DreamersListAdapter.ViewHolder) {
            ViewHolder holder = (ViewHolder) viewHolder;

            Dreamer dreamer = dreamersList.get(position);
            Avatar avatar = dreamer.getAvatar();

            imageLoader.displayImage(avatar.getMediumUrl(), holder.dreamerPhoto, imageOptions);
            holder.dreamerFullName.setText(dreamer.getFullName());
            holder.ageAndLocationDreamer.setText(StringAppendingComponent.getDreamerInfo(dreamer));
            if (dreamer.getGender().equals(Field.MALE)) {
                holder.imgDreamerGender.setBackgroundResource(R.mipmap.ic_gender_male);
            } else {
                holder.imgDreamerGender.setBackgroundResource(R.mipmap.ic_gender_female);
            }

            if (dreamer.isVip()) {
                holder.dreamerStatus.setVisibility(View.VISIBLE);
            } else {
                holder.dreamerStatus.setVisibility(View.GONE);
            }
        } else if (viewHolder instanceof ProgressViewHolder) {
            ProgressViewHolder progressViewHolder = (ProgressViewHolder) viewHolder;
            progressViewHolder.footerProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        pagination = paginationHelper.getPaginationData();
        if (dreamersList == null) {
            return 0;
        } else {
            if (pagination.getTotalCount() == dreamersList.size()) {
                return dreamersList.size();
            } else {
                return dreamersList.size() + 1;
            }
        }
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        @Bind(R.id.dreamer_photo)
        CircleImageView dreamerPhoto;
        @Bind(R.id.dreamer_full_name)
        TextView dreamerFullName;
        @Bind(R.id.img_dreamer_gender)
        ImageView imgDreamerGender;
        @Bind(R.id.dreamer_status)
        RelativeLayout dreamerStatus;
        @Bind(R.id.age_and_location_dreamer)
        TextView ageAndLocationDreamer;

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
