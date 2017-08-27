package com.mydreams.android.utils;

import android.support.annotation.NonNull;

import java.io.File;
import java.io.IOException;

public class FileUtils
{
	@NonNull
	public static File createTempFile(File folderDir) throws IOException
	{
		String filePrefixName = "TEMP_";
		return File.createTempFile(
				filePrefixName,  /* prefix */
				".jpg",         /* suffix */
				folderDir      /* directory */
		);
	}
}
