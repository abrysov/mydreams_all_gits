package com.mydreams.android.adapters;

import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.ViewGroup;

import com.annimon.stream.Stream;
import com.mydreams.android.utils.MapCollector;

import java.util.HashMap;
import java.util.Map;

/**
 * TODO когда добавится поддержка хедера в {@link ArrayAdapter} следует предусмотреть коррекцию позиции при вызове методов notifyItemRangeRemoved и других
 */
public class DifferentViewAdapter<TEnum extends Enum<TEnum>> extends ArrayAdapter<Object, BaseViewHolder>
{
	private static final int NORMAL_VIEW_TYPE_MASK = 1 << 16;
	private static final int FOOTER_VIEW_TYPE = NORMAL_VIEW_TYPE_MASK << 1;
	@NonNull
	private final Map<TEnum, Binder<TEnum>> mBindersMapping;
	@Nullable
	private IFooterViewBinder mFooterViewBinder;
	@LayoutRes
	private Integer mFooterViewLayoutId;
	private boolean showFooter;

	public DifferentViewAdapter()
	{
		mBindersMapping = new HashMap<>();
	}

	@SafeVarargs
	public DifferentViewAdapter(@NonNull Binder<TEnum>... binders)
	{
		mBindersMapping = new HashMap<>(Stream.of(binders).collect(MapCollector.toMap(Binder::getType, v -> v)));
	}

	@NonNull
	@Override
	public Object getItem(int position)
	{
		if (isFooterPosition(position))
			throw new IllegalStateException("Невозможно получить объект для футтера");

		return super.getItem(position);
	}

	@Override
	public int getItemCount()
	{
		int externalItemCount = 0;

		if (shouldShowFooter())
			externalItemCount++;

		return super.getItemCount() + externalItemCount;
	}

	@Override
	public int getItemViewType(int position)
	{
		if (isFooterPosition(position))
			return FOOTER_VIEW_TYPE;

		TEnum type = getEnumFromPosition(position);
		return type.ordinal() | NORMAL_VIEW_TYPE_MASK;
	}

	@Override
	public void onBindViewHolder(BaseViewHolder holder, int position)
	{
		if (isFooterPosition(position))
		{
			if (mFooterViewBinder != null)
			{
				mFooterViewBinder.onBindFooterView(holder);
			}
		}
		else
		{
			Object item = getItem(position);
			holder.setItem(item);
		}
	}

	@Override
	public BaseViewHolder onCreateViewHolder(ViewGroup parent, int viewType)
	{
		if (viewType == FOOTER_VIEW_TYPE)
		{
			if (!shouldShowFooter())
				throw new IllegalStateException("Невозможно создать ViewHolder для футтера, не задан layout id для футтера");

			return new BaseViewHolder(mFooterViewLayoutId, parent)
			{
				@Override
				public void setItem(@NonNull Object item)
				{
				}
			};
		}
		else if ((viewType & NORMAL_VIEW_TYPE_MASK) != 0)
		{
			int normalViewType = viewType & ~NORMAL_VIEW_TYPE_MASK;

			TEnum type = getEnumFromViewType(normalViewType);

			if (!mBindersMapping.containsKey(type))
				throw new IllegalStateException("Неудалось найти биндер для enum type " + type);

			Binder binder = mBindersMapping.get(type);
			return binder.createViewHolder(parent);
		}

		throw new IllegalStateException("Неудалось создать BaseViewHolder, viewType=" + viewType);
	}

	public void addBinder(@NonNull Binder<TEnum> binder)
	{
		mBindersMapping.put(binder.getType(), binder);
	}

	/**
	 * @return реальное количество элементов, без учёта хедера и футтера
	 */
	public int getAdapterItemCount()
	{
		return super.getItemCount();
	}

	public boolean isShowFooter()
	{
		return showFooter;
	}

	public void setShowFooter(boolean showFooter)
	{
		this.showFooter = showFooter;
		notifyDataSetChanged();
	}

	public void setFooterView(@LayoutRes @Nullable Integer layoutId, @Nullable IFooterViewBinder footerViewBinder)
	{
		mFooterViewLayoutId = layoutId;
		mFooterViewBinder = layoutId != null ? footerViewBinder : null;
		notifyDataSetChanged();
	}

	public void setFooterView(@LayoutRes @Nullable Integer layoutId)
	{
		setFooterView(layoutId, null);
	}

	@NonNull
	protected TEnum getEnumFromPosition(int position)
	{
		Object item = getItem(position);
		TEnum result = Stream.of(mBindersMapping.entrySet())
				.filter(x -> x.getValue().canHandle(item))
				.map(Map.Entry::getKey)
				.findFirst()
				.orElse(null);

		if (result == null)
			throw new IllegalStateException("Небыл найден binder для типа:" + item.getClass().getName());

		return result;
	}

	@NonNull
	protected TEnum getEnumFromViewType(int viewType)
	{
		TEnum result = Stream.of(mBindersMapping.keySet())
				.filter(x -> x.ordinal() == viewType)
				.findFirst()
				.orElse(null);

		if (result == null)
			throw new IllegalStateException("Небыл найден enum для viewType:" + viewType);

		return result;
	}

	private boolean isFooterPosition(int position)
	{
		return shouldShowFooter() && position == getItemCount() - 1;
	}

	private boolean shouldShowFooter()
	{
		return isShowFooter() && mFooterViewLayoutId != null;
	}

	public interface IFooterViewBinder
	{
		void onBindFooterView(@NonNull BaseViewHolder viewHolder);
	}

	public static abstract class Binder<TEnum extends Enum<TEnum>>
	{
		@NonNull
		private final TEnum mType;

		public Binder(@NonNull TEnum type)
		{
			mType = type;
		}

		public abstract boolean canHandle(@NonNull Object item);

		@NonNull
		public abstract BaseViewHolder createViewHolder(@NonNull ViewGroup parent);

		@NonNull
		public TEnum getType()
		{
			return mType;
		}
	}
}
