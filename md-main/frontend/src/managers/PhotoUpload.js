import Routes from "routes";
import { request } from "lib/ajax";

export function uploadPostPhotos(photos, onPhotoUpload) {
  for (var i = 0; i < photos.length; i++) {
    const formData = new FormData();
    formData.append('photo', photos[i]);

    request(Routes.api_web_post_photos_path(), "POST", formData)
    .then(r => r.json())
    .then(r => onPhotoUpload(r.post_photo));
  }
}
