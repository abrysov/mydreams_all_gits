package com.mydreams.android.service.gson.adapters;

import com.annimon.stream.Stream;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import com.mydreams.android.service.models.AgeRange;
import com.mydreams.android.utils.ObjectUtils;

import java.io.IOException;

public class AgeRangeAdapter extends TypeAdapter<AgeRange>
{
	@Override
	public AgeRange read(JsonReader in) throws IOException
	{
		String stringValue = in.nextString();
		return Stream.of(AgeRange.values()).filter(x -> ObjectUtils.equals(x.getRange(), stringValue)).findFirst().orElse(AgeRange.None);
	}

	@Override
	public void write(JsonWriter out, AgeRange value) throws IOException
	{
		out.value(value != null ? value.getRange() : null);
	}
}
