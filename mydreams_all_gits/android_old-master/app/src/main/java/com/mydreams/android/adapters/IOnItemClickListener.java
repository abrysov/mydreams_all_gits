package com.mydreams.android.adapters;

import android.support.annotation.NonNull;

public interface IOnItemClickListener<T>
{
	void OnClick(@NonNull T item, int position);
}
