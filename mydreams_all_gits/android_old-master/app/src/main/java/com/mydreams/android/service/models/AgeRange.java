package com.mydreams.android.service.models;

public enum AgeRange
{
	None("None"),
	_1("18-25"),
	_2("25-32"),
	_3("32-39"),
	_4("39-46"),
	_5("46-53");

	private String mRange;

	AgeRange(final String range)
	{

		mRange = range;
	}

	public String getRange()
	{
		return mRange;
	}

	public void setRange(String range)
	{
		mRange = range;
	}
}
