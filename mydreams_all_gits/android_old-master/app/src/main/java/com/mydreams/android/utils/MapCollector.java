package com.mydreams.android.utils;

import com.annimon.stream.Collector;
import com.annimon.stream.function.BiConsumer;
import com.annimon.stream.function.Function;
import com.annimon.stream.function.Supplier;

import java.util.HashMap;
import java.util.Map;

public final class MapCollector
{
	public static <TItem, TKey, TValue> Collector<TItem, Map<TKey, TValue>, Map<TKey, TValue>>
	toMap(Function<? super TItem, ? extends TKey> keySelector, Function<? super TItem, ? extends TValue> valueSelector)
	{
		return new Collector<TItem, Map<TKey, TValue>, Map<TKey, TValue>>()
		{
			@Override
			public BiConsumer<Map<TKey, TValue>, TItem> accumulator()
			{
				return (map, item) -> map.put(keySelector.apply(item), valueSelector.apply(item));
			}

			@Override
			public Function<Map<TKey, TValue>, Map<TKey, TValue>> finisher()
			{
				return null;
			}

			@Override
			public Supplier<Map<TKey, TValue>> supplier()
			{
				return HashMap::new;
			}
		};
	}
}
