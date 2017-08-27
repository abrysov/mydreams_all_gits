package com.mydreams.android.modules;

import com.mydreams.android.components.SelectionPhotoDialog;

import dagger.Module;
import dagger.Provides;


/**
 * Created by mikhail on 16.03.16.
 */
@Module()
public class SelectionPhotoModule {

    @Provides
    SelectionPhotoDialog providePhotoDialog() {
        return new SelectionPhotoDialog();
    }
}
