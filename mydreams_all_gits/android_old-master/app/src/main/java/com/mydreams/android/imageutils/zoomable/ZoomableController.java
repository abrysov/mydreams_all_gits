/*
 * This file provided by Facebook is for non-commercial testing and evaluation
 * purposes only.  Facebook reserves all rights not expressly granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.mydreams.android.imageutils.zoomable;

import android.graphics.Matrix;
import android.graphics.RectF;
import android.view.MotionEvent;

/**
 * Interface for implementing a controller that works with {@link ZoomableDraweeView}
 * to control the zoom.
 */
public interface ZoomableController
{

	/**
	 * Gets the current scale factor. A convenience method for calculating the scale from the
	 * transform.
	 *
	 * @return the current scale factor
	 */
	float getScaleFactor();

	/**
	 * Gets the current transform.
	 *
	 * @return the transform
	 */
	Matrix getTransform();

	/**
	 * Gets whether the controller is enabled. This should return the last value passed to
	 * {@link #setEnabled}.
	 *
	 * @return whether the controller is enabled.
	 */
	boolean isEnabled();

	/**
	 * Enables the controller. The controller is enabled when the image has been loaded.
	 *
	 * @param enabled whether to enable the controller
	 */
	void setEnabled(boolean enabled);

	/**
	 * Allows the controller to handle a touch event.
	 *
	 * @param event the touch event
	 * @return whether the controller handled the event
	 */
	boolean onTouchEvent(MotionEvent event);

	/**
	 * Sets the bounds of the image post transform prior to application of the zoomable
	 * transformation.
	 *
	 * @param imageBounds the bounds of the image
	 */
	void setImageBounds(RectF imageBounds);

	/**
	 * Sets the listener for the controller to call back when the matrix changes.
	 *
	 * @param listener the listener
	 */
	void setListener(Listener listener);

	/**
	 * Sets the bounds of the view.
	 *
	 * @param viewBounds the bounds of the view
	 */
	void setViewBounds(RectF viewBounds);

	/**
	 * Listener interface.
	 */
	interface Listener
	{

		/**
		 * Notifies the view that the transform changed.
		 *
		 * @param transform the new matrix
		 */
		void onTransformChanged(Matrix transform);
	}
}