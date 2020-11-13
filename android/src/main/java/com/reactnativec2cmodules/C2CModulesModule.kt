package com.reactnativec2cmodules

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.util.Log
import android.view.WindowManager
import com.facebook.react.bridge.*
import com.zhihu.matisse.Matisse
import com.zhihu.matisse.MimeType
import com.zhihu.matisse.engine.impl.GlideEngine


class C2CModulesModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  private var mPickerPromise: Promise? = null


  override fun getName(): String {
      return "C2CModules"
  }

  @ReactMethod
  fun onFullScreen() {
    UiThreadUtil.runOnUiThread {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        currentActivity!!.window.attributes.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
      }
    }
  }

  @ReactMethod
  fun offFullScreen() {
    UiThreadUtil.runOnUiThread {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        currentActivity!!.window.attributes.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_DEFAULT
      }
    }
  }

  private val mActivityEventListener: ActivityEventListener = object : BaseActivityEventListener() {
    override fun onActivityResult(activity: Activity, requestCode: Int, resultCode: Int, data: Intent) {
      if (requestCode == 23) {
        val uriList = Matisse.obtainResult(data);
        val response: WritableArray = WritableNativeArray();
        for (uri in uriList) {
          response.pushString(uri.toString());
        }
        mPickerPromise?.resolve(response)
        Log.d("Matisse", "Uris: " + Matisse.obtainResult(data));
        Log.d("Matisse", "Paths: " + Matisse.obtainPathResult(data));
        Log.e("Matisse", "Use the selected photos with original: " + Matisse.obtainOriginalState(data));
      }
    }
  }

  @ReactMethod
  fun launchPicker(promise: Promise) {
    val currentActivity = currentActivity
    if (currentActivity == null) {
      promise.reject("E_ACTIVITY_DOES_NOT_EXIST", "Activity doesn't exist")
      return
    }
    mPickerPromise = promise
    try {
      Matisse.from(currentActivity!!)
        .choose(MimeType.ofAll())
        .countable(true)
        .maxSelectable(12)
        .thumbnailScale(0.85f)
        .imageEngine(GlideEngine())
        .showPreview(false)
        .maxOriginalSize(5)
        .forResult(23)
    } catch (e: Exception) {
      mPickerPromise!!.reject("E_FAILED_TO_SHOW_PICKER", e);
      mPickerPromise = null;
    }
  }

  init {
    reactContext.addActivityEventListener(mActivityEventListener);
  }
}
