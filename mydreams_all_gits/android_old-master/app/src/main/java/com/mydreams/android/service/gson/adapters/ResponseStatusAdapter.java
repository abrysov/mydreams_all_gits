package com.mydreams.android.service.gson.adapters;

import com.annimon.stream.Stream;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import com.mydreams.android.service.models.ResponseStatus;

import java.io.IOException;

public class ResponseStatusAdapter extends TypeAdapter<ResponseStatus>
{
	@Override
	public ResponseStatus read(JsonReader in) throws IOException
	{
		int intValue = in.nextInt();
		return Stream.of(ResponseStatus.values()).filter(x -> x.getId() == intValue).findFirst().orElse(ResponseStatus.Unknown);
	}

	@Override
	public void write(JsonWriter out, ResponseStatus value) throws IOException
	{
		out.value(value.getId());
	}
}
