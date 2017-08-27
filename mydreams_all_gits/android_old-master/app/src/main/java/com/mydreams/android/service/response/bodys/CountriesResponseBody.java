package com.mydreams.android.service.response.bodys;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.CountryDto;

import java.util.List;

public class CountriesResponseBody
{
	@SerializedName("countries")
	private List<CountryDto> countries;

	public List<CountryDto> getCountries()
	{
		return countries;
	}

	public void setCountries(final List<CountryDto> countries)
	{
		this.countries = countries;
	}
}
