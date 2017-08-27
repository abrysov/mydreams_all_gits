package com.mydreams.android.service.response.bodys;

import com.mydreams.android.service.models.PhotoDto;

public class UploadPhotoResponseBody
{
	private PhotoDto photo;

	public PhotoDto getPhoto()
	{
		return photo;
	}

	public void setPhoto(PhotoDto photo)
	{
		this.photo = photo;
	}
}
