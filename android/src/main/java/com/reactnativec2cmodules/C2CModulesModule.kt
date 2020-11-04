package com.reactnativec2cmodules

import android.os.Build
import android.view.WindowManager
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.UiThreadUtil

class C2CModulesModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

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


}
