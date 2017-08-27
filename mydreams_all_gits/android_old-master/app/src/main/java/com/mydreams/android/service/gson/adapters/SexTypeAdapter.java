package com.mydreams.android.service.gson.adapters;

import com.annimon.stream.Stream;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import com.mydreams.android.service.models.SexType;

import java.io.IOException;

public class SexTypeAdapter extends TypeAdapter<SexType>
{
	@Override
	public SexType read(JsonReader in) throws IOException
	{
		int intValue = in.nextInt();
		return Stream.of(SexType.values()).filter(x -> x.getId() == intValue).findFirst().orElse(SexType.Unknown);
	}

	@Override
	public void write(JsonWriter out, SexType value) throws IOException
	{
		out.value(value != null ? value.getId() : null);
	}
}
