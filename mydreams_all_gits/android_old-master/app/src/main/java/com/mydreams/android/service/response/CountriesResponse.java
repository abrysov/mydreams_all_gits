package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.CountryDto;
import com.mydreams.android.service.response.bodys.CountriesResponseBody;

import java.util.ArrayList;
import java.util.List;

public class CountriesResponse extends BaseServiceResponse<CountriesResponseBody>
{
	@NonNull
	public List<CountryDto> getCountries()
	{
		List<CountryDto> list = getBody().getCountries();
		return list != null ? list : new ArrayList<>();
	}

}
